"""
Must be called from the `vivado_evaluator` directory.
"""
import os
import sys
import time
import json
from evaluators import do_task
from verilog_processing import change_vivado_width

assert os.getcwd() == os.path.expanduser("~/src/hls_bench/vivado_evaluator")

BENCH_PATH = "bench"
LOG_PATH = "log"
FAST_TABLE_FILE = "fast_table.json"  # (const file) stores a table of which verilog is faster than which
TASK_FILE = "tasks.json"  # (const file) stores a list of tasks

GROUP_PATH = "../guannan/exp_2"  # path to benchmark groups
GLOBAL_TASK_FILE = "global_tasks.json"  # manually configured, should be a JSON list of `group_path`s, e.g. ["gcd"]
GLOBAL_PROGRESS_FILE = "global_progress.json"  # (mutable file) used by multi-process workers
GLOBAL_LOG_FILE = "global_log.log"

DEFAULT_WIDTH = 4  # default width of all vivado-generated benchmarks. must be followed by all benchmarks.
WORKER_COUNT = 4  # number of workers to run in parallel, ordinarily equal to the number of cores


def _global_log_write_line(line: str):
    "helper function to write to the global log file. called by any worker, need to avoid race conditions."
    os.system(f"touch {GLOBAL_LOG_FILE}")  # create the file if it doesn't exist
    log_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
    with open(GLOBAL_LOG_FILE, "a") as f:
        f.write(f"[{log_time}] {line}\n")


def backup_newest_experiment_data():
    "backup the newest experiment data. can call manually, but also happens at the end of a task epoch."
    suffix = time.strftime("%y%m%d-%H%M%S", time.localtime())
    file_name = f"backup-{suffix}.zip"
    ret_code = os.system(f"zip -r {file_name} {GROUP_PATH}")
    if ret_code != 0:
        _global_log_write_line(f"backup ({file_name}) failed with code {ret_code}")
    else:
        _global_log_write_line(f"backup ({file_name}) succeeded, zip file is {file_name}")


def _is_no_slower_than(left_filename: str, right_filename: str) -> bool:
    "helper function to check if a verilog file design is 'no slower' than another"
    if left_filename == right_filename:
        return True
    left_modified = "left_modified.v"
    right_modified = "right_modified.v"
    dummy_log_file = "dummy_log.txt"
    change_vivado_width(left_filename, left_modified, DEFAULT_WIDTH, 3)  # change to 3-bit
    change_vivado_width(right_filename, right_modified, DEFAULT_WIDTH, 3)  # change to 3-bit
    do_task("nuxmv-fast", ".", left_modified, right_modified, dummy_log_file)
    with open(dummy_log_file, "r") as f:
        result = "Trace Type: Counterexample" not in f.read()
    for file in [left_modified, right_modified, dummy_log_file]:
        if os.path.exists(file):
            os.remove(file)
    return result


class FastTable:
    file_basenames: list[str]
    no_slower_than: dict[tuple[str, str], bool]

    def __eq__(self, other: "FastTable") -> bool:
        return self.__dict__ == other.__dict__
    
    def fill(self, group_name: str) -> "FastTable":
        folder = os.path.join(GROUP_PATH, group_name, BENCH_PATH)
        self.file_basenames = sorted(os.listdir(folder))
        self.no_slower_than = {}
        for basename_1 in self.file_basenames:
            filename_1 = os.path.join(folder, basename_1)
            for basename_2 in self.file_basenames:
                filename_2 = os.path.join(folder, basename_2)
                self.no_slower_than[(basename_1, basename_2)] = _is_no_slower_than(filename_1, filename_2)
        return self

    def load_from_file(self, file: str) -> "FastTable":
        def decode_key(key: str) -> tuple[str, str]:
            l, r = key.split(" VS ")
            return (l, r)

        with open(file, "r") as f:
            data = json.load(f)
        self.file_basenames = data["file_basenames"]
        self.no_slower_than = {decode_key(k): v for k, v in data["no_slower_than"].items()}
        return self

    def dump_to_file(self, file: str):
        def encode_key(key: tuple[str, str]) -> str:
            l, r = key
            return f"{l} VS {r}"

        data = {
            "file_basenames": self.file_basenames,
            "no_slower_than": {encode_key(k): v for k, v in self.no_slower_than.items()},
        }
        with open(file, "w") as f:
            json.dump(data, f, indent=4)


class Progress:
    "the progress of workers. the workers should finish the tasks one by one, and backup the experiment data in the end."
    next_task: tuple[int, int]
    backed_up: bool

    def load_from_file(self, file: str) -> "Progress":
        def decode_next_task(next_task: str) -> tuple[int, int]:
            group_index, task_index = next_task.split()
            return (int(group_index), int(task_index))

        if not os.path.exists(file):  # default initialization
            self.next_task = (0, 0)
            self.backed_up = False
            return self
        with open(file, "r") as f:
            data = json.load(f)
        self.next_task = decode_next_task(data["next_task"])
        self.backed_up = data["backed_up"]
        return self

    def dump_to_file(self, file: str):
        def encode_next_task(next_task: tuple[int, int]) -> str:
            group_index, task_index = next_task
            return f"{group_index} {task_index}"

        data = {
            "next_task": encode_next_task(self.next_task),
            "backed_up": self.backed_up,
        }
        with open(file, "w") as f:
            json.dump(data, f, indent=4)


class Task:
    group_name: str
    verilog_1_basename: str
    verilog_2_basename: str
    evaluator_name: str
    bit_widths: list[int]

    def __init__(self, group_name: str, verilog_1_basename: str, verilog_2_basename: str, evaluator_name: str, bit_widths: list[int]):
        self.group_name = group_name
        self.verilog_1_basename = verilog_1_basename
        self.verilog_2_basename = verilog_2_basename
        self.evaluator_name = evaluator_name
        self.bit_widths = bit_widths

    def __eq__(self, other: "Task"):
        return self.__dict__ == other.__dict__

    def _get_log_path(self, bit_width: int) -> str:
        name_1 = self.verilog_1_basename.replace(".v", "")
        name_2 = self.verilog_2_basename.replace(".v", "")
        log_basename = f"{name_1}-VS-{name_2}-BY-{self.evaluator_name}-AT-{bit_width}.log"
        return os.path.join(GROUP_PATH, self.group_name, LOG_PATH, log_basename)

    def to_str(self) -> str:
        return f"({self.group_name}, {self.verilog_1_basename}, {self.verilog_2_basename}, {self.evaluator_name}, {self.bit_widths})"

    def do(self):
        "actually do the task; NOTE: once timeout, skip the rest. NOTE: avoid race condition."
        folder = os.path.join(GROUP_PATH, self.group_name, BENCH_PATH)
        verilog_path_1 = os.path.join(folder, self.verilog_1_basename)
        verilog_path_2 = os.path.join(folder, self.verilog_2_basename)
        for bit_width in self.bit_widths:
            now = int(time.time() * 1_000_000)
            modified_path_1 = f"do_tmp_1_{now}.v"
            modified_path_2 = f"do_tmp_2_{now}.v"
            change_vivado_width(verilog_path_1, modified_path_1, DEFAULT_WIDTH, bit_width)
            change_vivado_width(verilog_path_2, modified_path_2, DEFAULT_WIDTH, bit_width)
            time_spent = do_task(self.evaluator_name, ".", modified_path_1, modified_path_2, self._get_log_path(bit_width))
            for file in [modified_path_1, modified_path_2]:
                if os.path.exists(file):
                    os.remove(file)
            if time_spent is None:  # don't waste time for longer bit widths
                break

    def is_done(self) -> bool:
        "check if the task is done, so we does not redo."
        return os.path.exists(self._get_log_path(self.bit_widths[0]))  # we regard entire task as is_done iff first bit_width is done


class TaskList:
    tasks: list[Task]

    def __eq__(self, other: "TaskList") -> bool:
        return self.__dict__ == other.__dict__

    def create(self, group_name: str, fast_table: FastTable) -> "TaskList":
        "create a list of tasks to do from the fast table."
        word_bit_widths = [8, 16, 32]
        kairos_bit_widths = [4, 5, 6, 7, 8]
        basenames = fast_table.file_basenames
        self.tasks = []
        for i in range(len(basenames)):
            basename_i = basenames[i]
            for j in range(i + 1, len(basenames)):
                basename_j = basenames[j]
                i_no_slower_than_j = fast_table.no_slower_than[(basename_i, basename_j)]
                j_no_slower_than_i = fast_table.no_slower_than[(basename_j, basename_i)]
                if i_no_slower_than_j and j_no_slower_than_i:
                    raise ValueError(f"{basename_i} and {basename_j} are no slower than each other. Trivial equivalence??")
                if i_no_slower_than_j:
                    self.tasks.append(Task(group_name, basename_i, basename_j, "word-fast", word_bit_widths))
                elif j_no_slower_than_i:
                    self.tasks.append(Task(group_name, basename_j, basename_i, "word-fast", word_bit_widths))
                self.tasks.append(Task(group_name, basename_i, basename_j, "word-even", word_bit_widths))
                self.tasks.append(Task(group_name, basename_j, basename_i, "word-even", word_bit_widths))
                self.tasks.append(Task(group_name, basename_i, basename_j, "nuxmv", kairos_bit_widths))
        return self

    def load_from_file(self, file: str) -> "TaskList":
        def decode_task(task: dict) -> Task:
            return Task(
                task["group_name"],
                task["verilog_1_basename"],
                task["verilog_2_basename"],
                task["evaluator_name"],
                [int(width) for width in task["bit_widths"].split()],
            )
        with open(file, "r") as f:
            data = json.load(f)
        self.tasks = [decode_task(task) for task in data["tasks"]]
        return self

    def dump_to_file(self, file: str):
        def encode_task(task: Task) -> dict:
            return {
                "group_name": task.group_name,
                "verilog_1_basename": task.verilog_1_basename,
                "verilog_2_basename": task.verilog_2_basename,
                "evaluator_name": task.evaluator_name,
                "bit_widths": ' '.join(str(width) for width in task.bit_widths),
            }
        with open(file, "w") as f:
            data = {"tasks": [encode_task(task) for task in self.tasks]}
            json.dump(data, f, indent=4)


def preprocess_group(group_name: str):
    "preprocess the group: preparing the fast table and the task list; create log folder if not exists."
    fast_table = FastTable().fill(group_name)
    fast_table_file = os.path.join(GROUP_PATH, group_name, FAST_TABLE_FILE)
    fast_table.dump_to_file(fast_table_file)
    assert FastTable().load_from_file(fast_table_file) == fast_table

    task_list = TaskList().create(group_name, fast_table)
    task_list_file = os.path.join(GROUP_PATH, group_name, TASK_FILE)
    task_list.dump_to_file(task_list_file)
    assert TaskList().load_from_file(task_list_file) == task_list

    log_folder = os.path.join(GROUP_PATH, group_name, LOG_PATH)
    if not os.path.exists(log_folder):
        os.mkdir(log_folder)


def _load_task_groups(group_names: list[str]) -> list[TaskList]:
    "load all tasks from all groups."
    task_groups = []
    for group_name in group_names:
        task_filepath = os.path.join(GROUP_PATH, group_name, TASK_FILE)
        task_groups.append(TaskList().load_from_file(task_filepath))
    return task_groups


def execute(worker_index: int):
    "execute the tasks parallelly."
    if worker_index not in range(WORKER_COUNT):
        raise ValueError(f"worker_index {worker_index} is out of range 0-{WORKER_COUNT - 1}")
    with open(GLOBAL_TASK_FILE, "r") as f:
        group_names = json.load(f)
    task_groups = _load_task_groups(group_names)
    start_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
    _global_log_write_line(f"worker {worker_index} ({start_time}) starts with task groups: {group_names}")

    while True:
        while int(time.time()) % (WORKER_COUNT * 2) != (worker_index * 2):  # simple anti-race condition hack
            print(f"Waiting for my turn... Now is {int(time.time())}", end="\r", flush=True)
            time.sleep(0.1)
        # Now, at most one worker falls through at any moment.
        # Theoretically, **there is chance of failure**, but we also have various recovery mechanisms.
        progress = Progress().load_from_file(GLOBAL_PROGRESS_FILE)
        if progress.backed_up: # all tasks are done
            _global_log_write_line(f"worker {worker_index} sees backing-up task has been claimed/done")
            break
        try:
            group_index, task_index = progress.next_task
            if group_index == len(task_groups):
                progress.backed_up = True
                progress.dump_to_file(GLOBAL_PROGRESS_FILE)
                _global_log_write_line(f"worker {worker_index} starts backing up...")
                backup_newest_experiment_data()  # when backup is done, this callee writes a global log
            else:
                curr_indices = (group_index, task_index)
                task = task_groups[group_index].tasks[task_index]
                task_index += 1
                if task_index == len(task_groups[group_index].tasks):
                    task_index = 0
                    group_index += 1
                progress.next_task = (group_index, task_index)
                progress.dump_to_file(GLOBAL_PROGRESS_FILE)
                if task.is_done():
                    _global_log_write_line(f"worker {worker_index} **skips** task {curr_indices}")
                else:
                    _global_log_write_line(f"worker {worker_index} starts task {curr_indices}: {task.to_str()}")
                    task.do()
                    _global_log_write_line(f"worker {worker_index} finishes task {curr_indices}: {task.to_str()}")
        except Exception as e:
            _global_log_write_line(f"worker {worker_index} ({start_time}) exits with exception {e.__class__.__name__}: {e}")
            raise e.with_traceback(None)  # re-print the traceback in console and exit the process

    _global_log_write_line(f"worker {worker_index} ({start_time}) finishes and exits")
    return


# The following are the main functions for the user to use. Function names are "prefix matched".
# - def preprocess_group(group_name: str)
# - def execute(worker_index: int)
if __name__ == "__main__":
    func = sys.argv[1]
    if func.startswith("p"):
        _, _, group_name = sys.argv
        preprocess_group(str(group_name))
    elif func.startswith("e"):
        _, _, worker_index = sys.argv
        execute(int(worker_index))
    else:
        raise ValueError(f"Unknown function {func}")
