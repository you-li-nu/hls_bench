import verilog_processing as vp
import config
import os

def inspect_benchmark_btor2(v_file: str) -> tuple[int, int, int]:
    temp_v = "inspect_temp.v"
    temp_btor2 = "inspect_temp.btor2"

    src = vp.VerilogFile()
    src.read_from_file(v_file)
    t1 = vp.merge_valid_signals(src)
    t2 = vp.remove_reset_signal(t1, False)
    t3 = vp.remove_nondeterminism(t2)
    dst = vp.split_fsm_into_bits(t3)
    dst.write_to_file(temp_v)

    yosys_commands = [
        f"read_verilog {temp_v}",
        "prep",
        "clean",
        "check",
        f"write_btor {temp_btor2}",   
    ]
    if os.system(f"{config.YOSYS_CMD} -q -p '{'; '.join(yosys_commands)}'") != 0:
        raise RuntimeError("Yosys failed.")

    # all below, assume line has been stripped:
    sort_id_to_width: dict[int, int] = {}

    def _is_node(line: str) -> bool:
        return len(line) > 0 and not line.startswith(";")

    def _is_sort(tokens: list[str]) -> bool:
        return tokens[1] == "sort"

    def _put_sort_width(tokens: list[str]) -> None:
        node_id, _, _, width = tokens
        sort_id_to_width[int(node_id)] = int(width)

    def _is_input_or_state(tokens: list[str]) -> bool:
        return tokens[1] == "input" or tokens[1] == "state"

    def _is_clk(tokens: list[str]) -> bool:
        if len(tokens) != 4:
            return False
        _, op, _, name = tokens
        return op == "input" and name.endswith("_clk")

    def _get_node_width(tokens: list[str]) -> int:
        sort_id = tokens[2]
        return sort_id_to_width[int(sort_id)]

    with open(temp_btor2, "r") as f:
        lines = f.readlines()

    btor2_node_count, bit_var_count, word_var_count = 0, 0, 0
    for line in lines:
        line = line.strip()
        if not _is_node(line):
            continue
        tokens = line.split()
        btor2_node_count += 1
        if _is_sort(tokens):
            _put_sort_width(tokens)
        elif _is_input_or_state(tokens) and not _is_clk(tokens):
            if _get_node_width(tokens) == 1:
                bit_var_count += 1
            else:
                word_var_count += 1

    for file in [temp_v, temp_btor2]:
        if os.path.exists(file):
            os.remove(file)
    return btor2_node_count, bit_var_count, word_var_count


from verilog_processing import change_vivado_width_with_config
def inspect_benchmark_aiger(v_file: str, bit_length: int, config_file: str) -> tuple[int, int]:
    "Returns the number of aiger nodes & flip flops"
    temp_v = "inspect_temp.v"
    temp_aig = "inspect_temp.aig"
    change_vivado_width_with_config(v_file, temp_v, 4, bit_length, config_file)

    yosys_commands = [
        f"read_verilog {temp_v}",
        f"synth",
        "flatten",
        "aigmap",
        f"write_aiger -ascii {temp_aig}",
    ]
    if os.system(f"{config.YOSYS_CMD} -q -p '{'; '.join(yosys_commands)}'") != 0:
        raise RuntimeError("Yosys failed.")

    with open(temp_aig, "r") as f:
        line = f.readline()
    _, _, _, latch_count_token, _, and_gate_count_token = line.strip().split()

    for file in [temp_v, temp_aig]:
        if os.path.exists(file):
            os.remove(file)
    return int(and_gate_count_token), int(latch_count_token)


def print_folder_benchmark_stats(folder: str) -> None:
    class MaxMin:
        mx: int
        mn: int
        def __init__(self):
            self.mx = -(2 ** 32)
            self.mn = 2 ** 32
        def update(self, val: int):
            self.mx = max(val, self.mx)
            self.mn = min(val, self.mn)

    node_mm, bit_mm, word_mm = MaxMin(), MaxMin(), MaxMin()
    ag_mm, ff_mm = MaxMin(), MaxMin()

    assert folder.endswith("/bench")
    changer_config_path = os.path.join(folder.replace("/bench", ""), "changer_config.py")
    for v_basename in sorted(os.listdir(folder)):
        if not v_basename.endswith(".v"):
            continue
        v_file = os.path.join(folder, v_basename)
        btor2_node_count, bit_var_count, word_var_count = inspect_benchmark_btor2(v_file)
        for bit_width in [8, 16, 32]:
            ag_count, ff_count = inspect_benchmark_aiger(v_file, bit_width, changer_config_path)
            ag_mm.update(ag_count)
            ff_mm.update(ff_count)
            print(f"[{bit_width}: {ag_count}, {ff_count}]", end=" ")
        print("name/node/bitvar/wordvar:", v_basename, btor2_node_count, bit_var_count, word_var_count)
        for mm, v in zip([node_mm, bit_mm, word_mm], [btor2_node_count, bit_var_count, word_var_count]):
            mm.update(v)
    print(f"node count range: {node_mm.mn} to {node_mm.mx}")
    print(f"bit var count range: {bit_mm.mn} to {bit_mm.mx}")
    print(f"word var count range: {word_mm.mn} to {word_mm.mx}")
    print(f"and gate count range: {ag_mm.mn} to {ag_mm.mx}")
    print(f"ff count range: {ff_mm.mn} to {ff_mm.mx}")


class InstanceResult:
    group_name: str
    verilog_1_basename: str
    verilog_2_basename: str
    evaluator_name: str
    word_width: int
    completed: bool
    invalid: bool
    # if not `self.completed`, the following fields till end are UB:
    time_spent: float
    # if `self.evaluator_name` is not ours, the following fields till end are UB:
    frame_count: int
    net_clause_count: int
    sat_query_count: int

    def from_log(self, log_path: str) -> "InstanceResult":
        self.invalid = False
        path_segments = os.path.normpath(log_path).split(os.path.sep)
        self.group_name, log_folder, log_basename = path_segments[-3:]
        assert log_folder == "log" and log_basename.endswith(".log")
        self.verilog_1_basename, rest = log_basename.split("-VS-")
        self.verilog_2_basename, rest = rest.split("-BY-")
        self.evaluator_name, rest = rest.split("-AT-")
        self.word_width = int(rest.removesuffix(".log"))
        with open(log_path, "r") as f:
            log_text = f.read()
        self._read_final_result(log_text)
        if self.evaluator_name.startswith("word") and self.completed:
            if not self._read_stats(log_text):
                self.completed = False  # non-equivalent, invalid
                self.invalid = True
        return self

    def _read_final_result(self, log_text: str):
        _, final_result = log_text.split("======== FINAL RESULT: ========")
        _, _, _, exit_code_line, time_line = final_result.strip().splitlines()
        if "Failure" in exit_code_line:
            self.completed = False
        elif "Success" in exit_code_line:
            if "out of memory" in log_text:
                self.completed = False
            else:
                self.completed = True
                self.invalid = False
                _, _, time_str, _ = time_line.strip().split()
                self.time_spent = float(time_str)
        else:
            raise ValueError(f"Unexpected exit_code_line: {exit_code_line}")

    def _read_stats(self, log_text: str) -> bool:
        if "Equivalent." not in log_text:
            assert "Nonequivalent." in log_text
            return False
        lines = [l.strip() for l in log_text.splitlines()]
        for line in lines:
            if line.startswith("# net clauses: "):
                self.net_clause_count = int(line.split()[-1])
            elif line.startswith("# total frames: "):
                self.frame_count = int(line.split()[-1])
            elif line.startswith("TOTAL = "):
                self.sat_query_count = int(line.split()[-1])
        assert all(x > 0 for x in [self.net_clause_count, self.frame_count, self.sat_query_count])
        return True

    def from_merged(self, l: "InstanceResult", r: "InstanceResult", virtual_name: str) -> "InstanceResult":
        "Merge two results for a 'virtual solver', where the shorter-time run gets dominated."
        assert l.group_name == r.group_name
        assert {l.verilog_1_basename, l.verilog_2_basename} == {r.verilog_1_basename, r.verilog_2_basename}
        assert l.word_width == r.word_width
        self.invalid = False
        self.group_name = l.group_name
        self.verilog_1_basename = l.verilog_1_basename
        self.verilog_2_basename = l.verilog_2_basename
        self.evaluator_name = virtual_name  # virtual evaluator
        self.word_width = l.word_width
        if l.completed and r.completed:
            better = l if l.time_spent <= r.time_spent else r
        else:
            better = l if l.completed else (r if r.completed else None)
        if better is None:
            self.completed = False
        else:
            self.completed = True
            self.invalid = False
            self.time_spent = better.time_spent
            self.frame_count = better.frame_count
            self.net_clause_count = better.net_clause_count
            self.sat_query_count = better.sat_query_count
        return self


# def summarize_group_as_instances()


class PerformanceSummarizer:
    group_names: str  # needed for calculating max score
    instace_results: list[InstanceResult]  # all intereted (+ virtual) instance results
    total_2_branch: int  # number of 2-branch compatible benchmarks (#pairs; a.k.a. max score)
    total_3_branch: int  # number of 3-branch compatible benchmarks (#pairs; a.k.a. max score)
    config_to_finished: dict[tuple[str, int], list[float]]  # mapping (instance, word_width) to sorted finish times


if __name__ == "__main__":
    group_names = ["kalman"] #os.listdir("../guannan/exp_2")
    counter = {}
    for group_name in group_names:
        log_dir = os.path.join("../guannan/exp_2", group_name, "log")
        for log_file in sorted(os.listdir(log_dir)):
            try:
                log_path = os.path.join(log_dir, log_file)
                result = InstanceResult().from_log(log_path)
                # print(result.__dict__)
                if result.completed:
                    key = (result.evaluator_name, result.word_width)
                    value = counter.get(key, set())
                    value.add(tuple(sorted((result.verilog_1_basename, result.verilog_2_basename))))
                    counter[key] = value
            except Exception as e:
                print(f"Failed to parse {log_file}: {e}")
        for bit in [8, 16, 32]:
            counter[("word-union", bit)] = counter.get(("word-fast", bit), set()) | counter.get(("word-even", bit), set())
            # counter[("word-intersect", bit)] = counter.get(("word-fast", bit), set()) & counter.get(("word-even", bit), set())
    # print({k: len(v) for k, v in counter.items()})
    for k, v in sorted(counter.items()):
        # if k[0] == "nuxmv":
            print(f"{k}: {len(v)}")
    # for group_name in sorted(os.listdir("../guannan/exp_2")):
    #     print_folder_benchmark_stats(os.path.join("../guannan/exp_2", group_name, "bench"))
    # print_folder_benchmark_stats("../guannan/exp_2/kalman/bench")