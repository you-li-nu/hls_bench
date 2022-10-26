import os
import sys
import config
import time
import subprocess
from verilog_processing import kairos_preprocess, avr_preprocess


class Evaluator:
    "Abstract base evaluator class. Don't implement."

    def preprocess(self, file_1: str, file_2: str):
        "Preprocess the files into a format the underlying tool can take."
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
    ]
    if os.system(f"{config.YOSYS_CMD} -q -p '{'; '.join(yosys_commands)}'") != 0:
        raise RuntimeError("Yosys failed.")


class AbcPdrKairosEvaluator(Evaluator):
    """
    Evaluator for the `pdr` implementation in the Berkeley `abc` tool for the Kairos product machine.
    """
    pm_verilog_file: str = "product_machine_temp.v"
    pm_aiger_file: str = "product_machine_temp.aig"

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
    pm_verilog_file: str = "product_machine_temp.v"
    pm_aiger_file: str = "product_machine_temp.aig"
    cmd_file: str = "nuxmv_cmd.txt"

    def preprocess(self, file_1: str, file_2: str):
        top_level_name = kairos_preprocess(file_1, file_2, self.pm_verilog_file)
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
    pm_verilog_file: str = "product_machine_temp.v"

    def preprocess(self, file_1: str, file_2: str):
        kairos_preprocess(file_1, file_2, self.pm_verilog_file)
        avr_preprocess(self.pm_verilog_file, self.pm_verilog_file)

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


tool_name_to_evaluator: dict[str, Evaluator] = {
    "abc": AbcPdrKairosEvaluator(),
    "nuxmv": NuxmvKairosEvaluator(),
    "avr": AvrKairosEvaluator(),
}

# Modify `config.py` before running this script.
# Usage example:
# $ python3 evaluators.py abc ../vivado_bench/gcd gcd_1.v gcd_2.v gcd_1_2_abc.log
if __name__ == "__main__":
    _, tool_name, folder, name_1, name_2, log_file = sys.argv
    evaluator = tool_name_to_evaluator[tool_name]
    evaluator.preprocess(os.path.join(folder, name_1), os.path.join(folder, name_2))
    time_elapsed = evaluator.evaluate(log_file)
    evaluator.cleanup()
    print("Time in secs:", time_elapsed)
