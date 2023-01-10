"""
this testing framework is developed based on pytest.
see quick start of pytest: https://docs.pytest.org/en/latest/example/simple.html

"""
import os
import subprocess
from pathlib import Path
import typing

import pytest
from ruamel.yaml import YAML
from lib.common import *
from lib import utils

yaml = YAML(typ="unsafe", pure=True)


def compare_results(result, golden_result):
    # Convert result and golden_result string to string lines with line ending stripped, then compare.
    assert list(yaml.load_all(result)) == list(yaml.load_all(golden_result))


print("##### K Language Grammar Test Suite #####")
# this stub test case exists to avoid the real test be skipped. ACI counts the skipped tests as failed tests, but in our pipeline it's valid
# when no test cases should be executed. To reach a 100% pass rate in that case, we add a stub case to the test cases.
test_dirs = utils.get_affected_stacks() or [STUB_CASE]


@pytest.mark.parametrize("test_dir", test_dirs)
def test_konfigs(test_dir):
    if test_dir == STUB_CASE:
        return
    print(f"Testing {test_dir}")
    test_dir = Path(test_dir)
    kcl_file_name = test_dir / MAIN_FILE
    ci_test_dir = test_dir / CI_TEST_DIR
    assert ci_test_dir.is_dir(), f"missing ci-test dir for test case: {kcl_file_name}"
    golden_file = ci_test_dir / STDOUT_GOLDEN_FILE
    assert golden_file.is_file(), f"missing golden file for main.k in dir {golden_file}"
    kusion_cmd = ["kusion"]
    kusion_cmd.append("compile")
    if utils.has_settings_file(ci_test_dir):
        kusion_cmd.append("-Y")
        kusion_cmd.append(f"{CI_TEST_DIR}/{SETTINGS_FILE}")
        kusion_cmd.append("-Y")
        kusion_cmd.append("kcl.yaml")
        kusion_cmd.append("-o")
        kusion_cmd.append("stdout")
    else:
        kusion_cmd.append(f"{MAIN_FILE}")
    process = subprocess.run(
        kusion_cmd, capture_output=True, cwd=test_dir, env=dict(os.environ)
    )
    stdout, stderr = process.stdout, process.stderr
    print(f"STDOUT:\n{stdout.decode()}")
    assert (
        process.returncode == 0 and len(stderr) == 0
    ), f"Error executing file {kcl_file_name}.\nexit code = {process.returncode}\nstderr = {stderr}"
    if process.returncode == 0 and len(stderr) == 0:
        try:
            with open(golden_file, "r") as golden:
                compare_results(stdout.decode(), golden)
        except FileNotFoundError:
            raise Exception(f"Error reading expected result from file {golden_file}")
