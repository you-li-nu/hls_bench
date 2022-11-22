import os
from typing import Callable

def change_vivado_width(src_file: str, dst_file: str, src_width: int, dst_width: int):
    "helper function to change the word width of a vivado-generated verilog file"
    with open(src_file, "r") as f:
        lines = f.readlines()

    to_find = f"[{src_width-1}:0]"
    to_replace = f"[{dst_width-1}:0]"
    fsm_str = "_fsm"

    new_lines = []
    for line in lines:
        if fsm_str in line: # don't change FSM width
            new_lines.append(line)
        else:
            new_lines.append(line.replace(to_find, to_replace))

    with open(dst_file, "w") as f:
        f.writelines(new_lines)


def change_vivado_width_with_config(src_file: str, dst_file: str, src_width: int, dst_width: int, config_file: str):
    "helper function to change the word width of a vivado-generated verilog file"
    if not os.path.exists(config_file):
        change_vivado_width(src_file, dst_file, src_width, dst_width)  # fall back to the original function
        return

    # dynamically load `changers` as code from config file
    assert src_width == 4
    changers: dict[str, Callable[[int], str]]
    with open(config_file, "r") as f:
        changers = eval(f.read())

    with open(src_file, "r") as f:
        lines = f.readlines()

    safe_changers: list[tuple[str, str]] = [None] * (2 * len(changers))
    i = 0
    for name, changer in changers.items():
        temp_str = f"$({i}:{hash(name)})$"
        safe_changers[i] = (name, temp_str)
        safe_changers[i + len(changers)] = (temp_str, changer(dst_width))
        i += 1

    fsm_str = "_fsm"
    for key, value in safe_changers:
        new_lines = []
        for line in lines:
            if fsm_str in line: # don't change FSM width
                new_lines.append(line)
            else:
                new_lines.append(line.replace(key, value))
        lines = new_lines

    with open(dst_file, "w") as f:
        f.writelines(lines)


def main(src_file: str, width: int):
    assert "bench/" in src_file and src_file.endswith(".v")
    dst_file = src_file.replace(".v", f"_width_{width}.v")
    change_vivado_width_with_config(src_file, dst_file, 4, width, os.path.join(src_file, "..", "changer_config.py"))


# usage example: python word_size_changer.py gcd/bench/gcd_1.v 16  ## generates gcd/bench/gcd_1_width_16.v
if __name__ == "__main__":
    import sys
    _, src_file, width = sys.argv
    main(src_file, int(width))