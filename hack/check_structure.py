"""
The test items for structure verification are as follows：
    - in project.yaml：name is required;
    - in stack.yaml：name is required
"""
from pathlib import Path
import pytest
from lib.common import *
from lib import util


def check_project_meta(project_dir: Path):
    yaml_content = util.read_to_yaml(str(project_dir / PROJECT_FILE))
    assert (
        yaml_content.get(NAME) is not None
    ), "file structure error: invalid project meta: project name undefined"


def check_stack_meta(stack_dir: Path):
    yaml_content = util.read_to_yaml(str(stack_dir / STACK_FILE))
    assert (
        yaml_content.get(NAME) is not None
    ), "file structure error: invalid stack meta: stack name undefined"


project_dirs = util.get_changed_projects()
stack_dirs = util.get_changed_stacks()


@pytest.mark.parametrize("project_dir", project_dirs)
def test_project_structure(project_dir: str):
    print(f"Check structure of project {project_dir}")
    check_project_meta(Path(project_dir))


@pytest.mark.parametrize("stack_dir", stack_dirs)
def test_stack_structure(stack_dir: str):
    print(f"Check structure of stack {stack_dir}")
    check_stack_meta(Path(stack_dir))
