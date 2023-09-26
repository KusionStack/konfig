import os
import subprocess
from pathlib import Path
import pytest
from lib.common import *
from lib import util


stack_dirs = util.get_changed_stacks()


@pytest.mark.parametrize("stack_dir", stack_dirs)
def test_correctness(stack_dir):
    print(f"Testing correctness of stack {stack_dir}...")
    cmd = [KUSION_CMD, COMPILE_CMD]
    process = subprocess.run(
        cmd, capture_output=True, cwd=Path(stack_dir), env=dict(os.environ)
    )
    stderr = process.stderr
    assert (
        process.returncode == 0 and len(stderr) == 0
    ), f"Correctness test of stack {stack_dir} failed\nexit code = {process.returncode}\nstderr = {stderr}"
