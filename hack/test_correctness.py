import os
import subprocess
from pathlib import Path
import pytest
from lib.common import *
from lib import util

stack_dirs = util.get_changed_stacks()
util.create_workspaces(stack_dirs)


@pytest.mark.parametrize("stack_dir", stack_dirs)
def test_correctness(stack_dir):
    if util.should_ignore_stack(stack_dir):
        print(f"Ignore stack {stack_dir}.")
        return
    print(f"Test correctness of stack {stack_dir}...")
    cmd = [KUSION_CMD, BUILD_CMD]
    process = subprocess.run(
        cmd, capture_output=True, cwd=Path(stack_dir), env=dict(os.environ)
    )
    assert (process.returncode == 0), f"Test correctness of stack {stack_dir} failed\n" \
                                      f"exit code = {process.returncode}\n" \
                                      f"stdout = {process.stdout}\n" \
                                      f"stderr = {process.stderr}"
