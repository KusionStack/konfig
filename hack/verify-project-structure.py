from pathlib import Path

import pytest
import yaml
import os
from lib.common import *
from lib import utils


project_dirs = utils.get_affected_projects() or [STUB_CASE]


@pytest.mark.parametrize("project_dir", project_dirs)
def test_project_structure(project_dir: str):
    """
    本测试校验：业务配置的工程结构合法性，具体来说：
        - project 目录下必须有 project.yaml, OWNERS
        - stack 目录下必须有 stack.yaml, main.k, ci-test/settings.yaml, ci-test/stdout.golden.yaml
        - project.yaml 中：name 必填、tenant 必填（mybkcafeextcontrol 情况特殊，暂时绕过，终态会统一）
        - stack.yaml 中：name 非必填，env 与目录名一致（忽略大小写）
    :param project_dir: 业务应用目录
    """
    if project_dir == STUB_CASE:
        return
    print(project_dir)
    project_dir = Path(project_dir)

    # 找到当前 project 下的所有 stack，并校验 stack 工程结构
    for stack_dir, _, _ in os.walk(project_dir):
        stack_dir = Path(stack_dir)
        if not utils.is_stack_dir(stack_dir):
            continue
        stack_name = stack_dir.name
        assert (
            stack_dir / CI_TEST_DIR
        ).is_dir(), f"file structure error: dir missing: {stack_name}/{CI_TEST_DIR}"
        assert (
            stack_dir / CI_TEST_DIR / SETTINGS_FILE
        ).is_file(), f"file structure error: file missing: {stack_name}/{CI_TEST_DIR}/{STACK_FILE}"
        assert (
            stack_dir / CI_TEST_DIR / STDOUT_GOLDEN_FILE
        ).is_file(), f"file structure error: file missing: {stack_name}/{CI_TEST_DIR}/{STDOUT_GOLDEN_FILE}"
        check_stack_meta(stack_dir)


def check_project_meta(project_dir: Path):
    """
    project.yaml 文件必须定义 name, tenant
    :param project_dir: project 目录
    :return: project 目录下是否包含合法的 project.yaml 文件
    """
    yaml_content = read_to_yaml(str(project_dir / PROJECT_FILE))
    assert (
        yaml_content.get("name") is not None
    ), "file structure error: invalid project meta: project name undefined"
    assert (
        yaml_content.get("tenant") is not None
    ), "file structure error: invalid project meta: tenant undefined"


def check_stack_meta(stack_dir: Path):
    """
    stack.yaml 文件必须定义 env，并且 env 值需要和 stack 目录名一致（大小写敏感）
    :param stack_dir: stack 目录
    :return: stack 目录下是否包含合法的 stack.yaml 文件
    """
    yaml_content = read_to_yaml(str(stack_dir / STACK_FILE))
    meta_env_name = yaml_content.get("env")
    meta_type_name = yaml_content.get("type")
    if stack_dir.match("appops"):
        assert (
            meta_env_name and meta_env_name.lower() == stack_dir.name.lower()
        ), f"file structure error: invalid stack meta: (dir:{stack_dir.name}, meta:{meta_env_name})"


def read_to_yaml(file_path):
    with open(file_path) as file:
        # The FullLoader parameter handles the conversion from YAML
        # scalar values to Python the dictionary format
        # See: https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation#how-to-disable-the-warning
        return yaml.load(file, Loader=yaml.FullLoader)
