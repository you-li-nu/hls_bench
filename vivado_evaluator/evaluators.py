import os
import sys
import config
import time
import subprocess
from verilog_processing import kairos_preprocess, avr_preprocess, ours_preprocess


class Evaluator:
    "Abstract base evaluator class. Don't implement."

    def preprocess(self, file_1: str, file_2: str):
        "Preprocess the files into a format the underlying tool can take."
        raise NotImplementedError

    def read_pm(self, file: str, bit_size: int):
        "Read the product machine directly from a file."
        raise NotImplementedError

    def evaluate(self, log_file: str) -> float:
        """
        Run the underlying tool.

        If exits normally, return the time elapsed in seconds, otherwise return `None`.
        The stdout of the tool is `tee`d to `log_file`; final info is also appended there.
        """
        raise NotImplementedError

    def cleanup(self):
        "Clean up the temporary files used by the evaluator."
        raise NotImplementedError


def _make_full_cmd(basic_cmd_line: str, log_file: str) -> str:
    "Helper function to construct a full command line."
    mem_limit = config.MEMORY_LIMIT_IN_MIB * 1024
    time_limit = config.TIME_LIMIT_IN_SECONDS
    return f"ulimit -v {mem_limit}; stdbuf --output=0 timeout {time_limit} {basic_cmd_line} 2>&1 | tee {log_file}; exit ${{PIPESTATUS[0]}}"


def _finalize_evaluation_info(log_file: str, start_time: str, cmd_line: str, exit_code: int, time_elapsed: float):
    "Helper function to append final info to `log_file`."
    with open(log_file, "a") as f:
        f.write(f"\n======== FINAL RESULT: ========\n")
        f.write(f"Start time: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(start_time))}\n")
        f.write(f"Command line: {cmd_line}\n")
        f.write(f"Memory constraint: {config.MEMORY_LIMIT_IN_MIB} MiB\n")
        f.write(f"Exit code: {exit_code} ({'Success' if exit_code == 0 else 'Failure'})\n")
        if time_elapsed is None:
            f.write(f"Timed out after {config.TIME_LIMIT_IN_SECONDS} seconds.\n")
        else:
            f.write(f"Time elapsed: {time_elapsed} seconds.\n")


def _common_run(basic_cmd_line, log_file):
    "Helper function to run the underlying tool."
    cmd_line = _make_full_cmd(basic_cmd_line, log_file)
    start_time = time.time()
    result = subprocess.run(cmd_line, shell=True, executable="/bin/bash")
    time_elapsed = (time.time() - start_time) if result.returncode != 124 else None
    _finalize_evaluation_info(log_file, start_time, basic_cmd_line, result.returncode, time_elapsed)
    return time_elapsed


def _verilog_to_aiger(verilog_file: str, aiger_file: str, top_level_name: str):
    "Helper function to convert Verilog to AIGER."
    yosys_commands = [
        f"read_verilog {verilog_file}",
        f"synth -top {top_level_name}",
        "flatten",
        "aigmap",
        f"write_aiger {aiger_file}",
        # f"write_aiger -symbols -ascii {aiger_file}",
    ]
    if os.system(f"{config.YOSYS_CMD} -q -p '{'; '.join(yosys_commands)}'") != 0:
        raise RuntimeError("Yosys failed.")


def _change_bit_size(verilog_file: str, new_bit_size: int):
    "Helper function to change the bit size of a Verilog file."
    with open(verilog_file, "r") as f:
        lines = f.readlines()
    with open(verilog_file, "w") as f:
        for line in lines:
            if line.startswith("`define N"):
                line = f"`define N {new_bit_size - 1}\n"
            f.write(line)


class AbcPdrKairosEvaluator(Evaluator):
    """
    Evaluator for the `pdr` implementation in the Berkeley `abc` tool for the Kairos product machine.
    """
    pm_verilog_file: str = "abc_product_machine_temp.v"
    pm_aiger_file: str = "abc_product_machine_temp.aig"

    def preprocess(self, file_1: str, file_2: str):
        top_level_name = kairos_preprocess(file_1, file_2, self.pm_verilog_file)
        _verilog_to_aiger(self.pm_verilog_file, self.pm_aiger_file, top_level_name)

    def evaluate(self, log_file: str) -> float:
        abc_commands = [
            f"read_aiger {self.pm_aiger_file}",
            "pdr",
        ]
        basic_cmd_line = f"{config.ABC_CMD} -c '{'; '.join(abc_commands)}'"
        return _common_run(basic_cmd_line, log_file)

    def cleanup(self):
        for file in [self.pm_verilog_file, self.pm_aiger_file]:
            if os.path.exists(file):
                os.remove(file)


class NuxmvKairosEvaluator(Evaluator):
    """
    Evaluator for the `nuXmv` tool's IC3 checker for the Kairos product machine.
    """
    pm_verilog_file: str
    pm_aiger_file: str
    cmd_file: str
    fast_slow_mode: bool

    def __init__(self, fast_slow_mode: bool):
        self.fast_slow_mode = fast_slow_mode
        now = int(time.time() * 1_000_000)  # make sure filename is unique for every run, avoid race condition
        self.pm_verilog_file = f"nuxmv_{now}.v"
        self.pm_aiger_file = f"nuxmv_{now}.aig"
        self.cmd_file = f"nuxmv_cmd_{now}.txt"

    def preprocess(self, file_1: str, file_2: str):
        top_level_name = kairos_preprocess(file_1, file_2, self.pm_verilog_file, self.fast_slow_mode)
        _verilog_to_aiger(self.pm_verilog_file, self.pm_aiger_file, top_level_name)
        nuxmv_commands = [
            f"read_aiger_model -i {self.pm_aiger_file}",
            "encode_variables",
            "build_boolean_model",
            "check_invar_ic3",
            "quit",
        ]
        with open(self.cmd_file, "w") as f:
            f.write("\n".join(nuxmv_commands))

    def read_pm(self, file: str, bit_size: int) -> int:
        assert os.system(f"cp {file} {self.pm_verilog_file}") == 0
        _change_bit_size(self.pm_verilog_file, bit_size)
        _verilog_to_aiger(self.pm_verilog_file, self.pm_aiger_file, "gcd_dest_m")
        nuxmv_commands = [
            f"read_aiger_model -i {self.pm_aiger_file}",
            "encode_variables",
            "build_boolean_model",
            "check_invar_ic3",
            "quit",
        ]
        with open(self.cmd_file, "w") as f:
            f.write("\n".join(nuxmv_commands))

    def evaluate(self, log_file: str) -> float:
        basic_cmd_line = f"{config.NUXMV_CMD} -source {self.cmd_file}"
        return _common_run(basic_cmd_line, log_file)

    def cleanup(self):
        for file in [self.pm_verilog_file, self.pm_aiger_file, self.cmd_file]:
            if os.path.exists(file):
                os.remove(file)


class AvrKairosEvaluator(Evaluator):
    """
    Evaluator for the `AVR` word-level tool for the Kairos product machine.
    """
    pm_verilog_file: str = "_avr_product_machine_temp.v"

    def preprocess(self, file_1: str, file_2: str):
        kairos_preprocess(file_1, file_2, self.pm_verilog_file)
        avr_preprocess(self.pm_verilog_file, self.pm_verilog_file)

    def read_pm(self, file: str, bit_size: int) -> int:
        assert os.system(f"cp {file} {self.pm_verilog_file}") == 0
        _change_bit_size(self.pm_verilog_file, bit_size)
        with open(self.pm_verilog_file, "r") as f:
            lines = f.readlines()
        assert lines[-1].startswith("endmodule")
        lines[-1] = "\n"
        lines.extend(["wire prop = !nequiv;\n", "wire prop_neg = !prop;\n", "assert property ( prop );\n", "endmodule"])
        with open(self.pm_verilog_file, "w") as f:
            f.writelines(lines)

    def evaluate(self, log_file: str) -> float:
        cwd = os.getcwd()
        src_path = os.path.abspath(self.pm_verilog_file)
        log_path = os.path.abspath(log_file)
        os.chdir(os.path.expanduser(config.AVR_PATH))
        basic_cmd_line = f"python3 {config.AVR_MAIN} -n temp {src_path} -a sa"
        result = _common_run(basic_cmd_line, log_path)
        os.chdir(cwd)
        return result

    def cleanup(self):
        for file in [self.pm_verilog_file]:
            if os.path.exists(file):
                os.remove(file)


class OursEvaluator(Evaluator):
    """
    Evaluator for our tool.
    """
    verilog_file_1: str
    verilog_file_2: str
    bit_level: bool
    fast_slow_mode: bool
    swap: bool

    def __init__(self, bit_level: bool, fast_slow_mode: bool, swap: bool):
        self.bit_level = bit_level
        self.fast_slow_mode = fast_slow_mode
        self.swap = swap
        now = int(time.time() * 1_000_000)  # make sure filename is unique for every run, avoid race condition
        self.verilog_file_1 = f"ours_vivado_1_{now}.v"
        self.verilog_file_2 = f"ours_vivado_2_{now}.v"

    def preprocess(self, file_1: str, file_2: str):
        ours_preprocess(file_1, self.verilog_file_1)
        ours_preprocess(file_2, self.verilog_file_2)

    def evaluate(self, log_file: str) -> float:
        b = "bit" if self.bit_level else "word"
        f = "fast" if self.fast_slow_mode else "even"
        l, r = (self.verilog_file_1, self.verilog_file_2) if not self.swap else (self.verilog_file_2, self.verilog_file_1)
        basic_cmd_line = f"python3 {config.OURS_MAIN} {l} {r} {f} {b}"
        return _common_run(basic_cmd_line, log_file)

    def cleanup(self):
        for file in [self.verilog_file_1, self.verilog_file_2]:
            if os.path.exists(file):
                os.remove(file)
            btor2_file = file.replace(".v", ".btor2")
            if os.path.exists(btor2_file):
                os.remove(btor2_file)


tool_name_to_evaluator: dict[str, Evaluator] = {
    # "abc": AbcPdrKairosEvaluator(),
    "nuxmv": NuxmvKairosEvaluator(False),
    # "avr": AvrKairosEvaluator(),
    # "ours-bit": OursEvaluator(True),
    "word-fast": OursEvaluator(False, True, False),
    "word-even": OursEvaluator(False, False, False),
    # "word-swap": OursEvaluator(False, False, True),
    "nuxmv-fast": NuxmvKairosEvaluator(True),
}

# Modify `config.py` before running this script.
# Usage example:
# $ python3 evaluators.py abc ../vivado_bench/gcd gcd_1.v gcd_2.v gcd_1_2_abc.log

def do_task(tool_name: str, folder: str, name_1: str, name_2: str, log_file: str) -> float:
    "Main function to evaluate and return the time elapsed (or `None` if timeout)."
    evaluator = tool_name_to_evaluator[tool_name]
    evaluator.preprocess(os.path.join(folder, name_1), os.path.join(folder, name_2))
    time_elapsed = evaluator.evaluate(log_file)
    evaluator.cleanup()
    print("Time in secs:", time_elapsed)
    return time_elapsed

# tool_name_to_i = {
    # "abc": [2, 3, 4, 5, 6, 8],                  # Process   3 , Order  2
    # "nuxmv": [2, 3, 4, 5, 6, 8],                # Process  2  , Order  2
    # "avr": [4, 5, 6, 8, 16, 32],                # Process   3 , Order 1
    # "ours-bit": [2, 3, 4, 5],                   # Process  2  , Order 1
    # "ours-word": [2, 3, 4, 5, 6, 8, 16, 32],    # Process 1   , Order 1
#     "word-fast": [2, 3, 4, 5, 6, 8, 16, 32],
#     "word-even": [2, 3, 4, 5, 6, 8, 16, 32],
#     "word-swap": [2, 3, 4, 5, 6, 8, 16, 32],
# }

if __name__ == "__main__":
    # pass
    do_task("nuxmv", "../guannan/exp_2/kalman/bench", "kalman_1_2_1.v", "kalman_1_2_1.v", "temp1.log")
    # do_task("word-even", "../vivado_bench/ellipf", "ellipf_1_2.v", "ellipf_2_3_2.v", "temp2.log")
    # do_task("nuxmv", "../guannan/exp_2/counter/bench", "counter_1.v", "counter_2.v", "temp.log")

    # files = sorted(os.listdir("../vivado_bench/gcd"))
    # eq_table = []
    # fast_table = []
    # for name_1 in files:
    #     eq_row = []
    #     fast_row = []
    #     for name_2 in files:
    #         do_task("nuxmv", "../vivado_bench/gcd", name_1, name_2, "temp2.log")
    #         with open("temp2.log", "r") as f:
    #             eq_row.append("Trace Type: Counterexample" not in f.read())
    #         do_task("nuxmv-fast", "../vivado_bench/gcd", name_1, name_2, "temp2.log")
    #         with open("temp2.log", "r") as f:
    #             fast_row.append("Trace Type: Counterexample" not in f.read())
    #     eq_table.append(eq_row)
    #     fast_table.append(fast_row)

    # print("Files:")
    # for i, file in enumerate(files):
    #     print(f"{i}: {file}")
    # tab = "\t"
    # print()
    # print("Fast table:")
    # print(f"{tab}{tab.join(str(i) for i in range(len(files)))}")
    # for i, row in enumerate(fast_table):
    #     print(f"{i}{tab}{tab.join(str(b) for b in row)}")
    # print()
    # print("Equivalence table:")
    # print(f"{tab}{tab.join(str(i) for i in range(len(files)))}")
    # for i, row in enumerate(eq_table):
    #     print(f"{i}{tab}{tab.join(str(b) for b in row)}")

    # _, tool_name, folder, name_1, name_2, log_file = sys.argv
    # tool_names = sys.argv[1:]
    # _, tool_name_ = sys.argv
    # _, name_1, name_2 = sys.argv
    # folder = "../vivado_bench/guannan"

    # _, worker_id, worker_count = sys.argv
    # worker_id = int(worker_id)
    # worker_count = int(worker_count)

    # folder = "../vivado_bench/gcd"
    # for tool_name in ["word-fast"]:
    #     designs = sorted(os.listdir(folder))
    #     for i in range(len(designs)):
    #         for j in range(len(designs)):
    #             name_1, name_2 = designs[i], designs[j]
    #             log_path = f"../temp_logs/guannan/{name_1}_vs_{name_2}.log"
    #             while int(time.time()) % (worker_count * 2) != (worker_id * 2):  # simple anti-race condition hack
    #                 print(f"Waiting for my turn... Now is {int(time.time())}", end="\r", flush=True)
    #                 time.sleep(0.1)
    #             # now, at most one worker falls through at any second
    #             print()
    #             if os.path.exists(log_path):
    #                 print(f"Skipping {log_path} ...")
    #                 continue  # skip if already exists
    #             else:
    #                 assert os.system(f"touch {log_path}") == 0
    #                 print(f"Starting {log_path} ...")
    #                 do_task(tool_name, folder, name_1, name_2, log_path)

    # folder = "../vivado_bench/guannan"
    # name = "gcd_fast_vs_buggy_kairos.v"
    # _, tool_name, name, bit_sizes = sys.argv
    # bit_sizes = [int(bit_size) for bit_size in bit_sizes.split(",")]

    # for bit_size in bit_sizes:
    #     evaluator = tool_name_to_evaluator[tool_name]
    #     evaluator.read_pm(os.path.join(folder, name), bit_size)
    #     short_name = name.split("_")[3]
    #     time_elapsed = evaluator.evaluate(f"../guannan/exp_1/{short_name}_{tool_name}_{bit_size}.log")
    #     evaluator.cleanup()
    #     print("Time in secs:", time_elapsed)

        # for i in tool_name_to_i[tool_name]:
            # name_1 = f"gcd_1_{i}bit.v"
            # name_2 = f"gcd_2_{i}bit.v"
            # log_file = f"../logs/guannan/{tool_name}-{i}bit.log"
            # log_file = f"play_temp.log"
            # do_task(tool_name, folder, name_1, name_2, log_file)
