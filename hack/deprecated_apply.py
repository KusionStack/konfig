from lib import utils
from lib.common import *
from pathlib import Path
import os
import sys
import subprocess


def apply(argv):
    change_files_str = os.getenv("CHANGED_FILE")
    print("changed files str:", change_files_str)

    if not change_files_str:
        print("no changed file")
        return
    else:
        stack_path_list = utils.get_stack_files_paths_from_change_paths(
            change_files_str
        )
        if not stack_path_list:
            print("no stack found")
            return
        print("found stacks:", *stack_path_list)
        apply_command = ["kusion", "apply", "-y=true"]
        for p in stack_path_list:
            print("kusion apply -w", p, "-y=true")
            process = subprocess.run(
                apply_command, capture_output=True, cwd=p, env=dict(os.environ)
            )
            # 任务结束，输出提示信息
            stdout, stderr = process.stdout, process.stderr
            if stdout.decode().strip() != "":
                print(stdout.decode().strip(), flush=True)
            if process.returncode != 0 or len(stderr) != 0:
                raise Exception(stderr.decode().strip(), process.returncode)


if __name__ == "__main__":
    apply(sys.argv)
