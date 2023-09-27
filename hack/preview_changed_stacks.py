import os
import subprocess
from pathlib import Path
from typing import List
import zipfile
from lib.common import *
from lib import util


report_dir = os.path.dirname(os.path.abspath(__file__)) + "/report"
os.makedirs(report_dir, exist_ok=True)
result_files = []
result_pack_path = report_dir + "/preview-result.zip"


# If succeeded, return True; if skipped, return False; if failed, exception
def preview_stacks(stack_dirs: List[str]) -> bool:
    stacks = []
    for stack_dir in stack_dirs:
        if not stack_dir:
            continue
        if util.should_ignore_stack(stack_dir):
            print(f"Ignore stack {stack_dir}.")
            continue
        stacks.append(stack_dir)
    if len(stacks) == 0:
        print(f"ignored or no changed stacks, skip preview")
        return False

    for stack in stacks:
        preview(stack)
    return True


def preview(stack_dir: str):
    print(f"Preview stack {stack_dir}...")
    cmd = [KUSION_CMD, PREVIEW_CMD, NO_STYLE_FLAG]
    process = subprocess.run(
        cmd, capture_output=True, cwd=Path(stack_dir), env=dict(os.environ)
    )
    if process.returncode == 0:
        write_to_result_file(process.stdout, stack_dir)
    else:
        raise Exception(f"preview stack {stack_dir} failed",
                        f"stdout = {process.stdout.decode().strip()}",
                        f"stderr = {process.stderr.decode().strip()}",
                        f"returncode = {process.returncode}")


def write_to_result_file(content: bytes, stack: str):
    result_file_path = report_dir + "/preview-result-" + stack.replace("/", "_")
    with open(result_file_path, 'w') as file:
        file.write(content.decode())
    result_files.append(result_file_path)


def pack_result_files():
    with zipfile.ZipFile(result_pack_path, 'w') as zipf:
        for file in result_files:
            arc_name = os.path.basename(file)
            zipf.write(file, arcname=arc_name)


stack_dirs = util.get_changed_stacks()
success = preview_stacks(stack_dirs)
if success:
    pack_result_files()
with open(os.environ[GITHUB_OUTPUT], 'a') as fh:
    print(f'preview_success={str(success).lower()}', file=fh)
