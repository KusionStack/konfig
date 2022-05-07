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


def find_test_dirs() -> typing.List[str]:
    projects = utils.filter_project_dir()
    result = []
    for project in projects:
        stack_dirs = [
            str(d) for d in project.iterdir() if d.is_dir() and utils.is_stack_dir(d)
        ]
        result.extend(stack_dirs)
    return result


def compare_results(result, golden_result):
    # Convert result and golden_result string to string lines with line ending stripped, then compare.
    assert list(yaml.load_all(result)) == list(yaml.load_all(golden_result))


print("##### K Language Grammar Test Suite #####")
# this stub test case exists to avoid the real test be skipped. ACI counts the skipped tests as failed tests, but in our pipeline it's valid
# when no test cases should be executed. To reach a 100% pass rate in that case, we add a stub case to the test cases.
test_dirs = find_test_dirs() or [STUB_CASE]


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
    kcl_command = ["kcl"]
    if utils.has_settings_file(ci_test_dir):
        kcl_command.append("-Y")
        kcl_command.append(f"{CI_TEST_DIR}/{SETTINGS_FILE} kcl.yaml")
    else:
        kcl_command.append(f"{MAIN_FILE}")
    process = subprocess.run(
        kcl_command, capture_output=True, cwd=test_dir, env=dict(os.environ)
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
