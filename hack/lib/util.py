import os
import subprocess
from pathlib import Path
from typing import List
import yaml
from .common import *


def merge_list_to_str(l: List[str]) -> str:
    return " ".join(l)


def split_str_to_list(s: str) -> List[str]:
    return [l for l in s.split(" ") if l]


def get_changed_projects() -> List[str]:
    changed_projects_str = os.getenv(CHANGED_PROJECTS) or ""
    return split_str_to_list(changed_projects_str)


def get_changed_stacks() -> List[str]:
    changed_stacks_str = os.getenv(CHANGED_STACKS) or ""
    return split_str_to_list(changed_stacks_str)


def detect_all_stacks(project_path: str) -> List[str]:
    stack_paths = []
    for root, dirs, files in os.walk(project_path):
        if STACK_FILE in files:
            stack_paths.append(root)
    return stack_paths


# there are some examples cannot get compiled and applied correctly
def should_ignore_stack(stack_path: str) -> bool:
    for project_path in IGNORE_PROJECTS:
        if stack_path.startswith(project_path):
            return True
    return False


# def create_workspaces(stack_paths: List[str]):
#     workspaces = detect_workspaces(stack_paths)
#     workspace_file_dir = get_workspace_file_dir()
#     for workspace in workspaces:
#         create_workspace(workspace, workspace_file_dir)


# def create_workspace(workspace: str, workspace_file_dir: str):
#     workspace_file = workspace_file_path(workspace_file_dir, workspace)
#     cmd = [KUSION_CMD, WORKSPACE_CMD, CREATE_CMD, workspace, FILE_FLAG, workspace_file]
#     process = subprocess.run(
#         cmd, capture_output=True, env=dict(os.environ)
#     )
#     if process.returncode != 0:
#         raise Exception(f"Create workspace {workspace} with file {workspace_file} failed",
#                         f"stdout = {process.stdout.decode().strip()}",
#                         f"stderr = {process.stderr.decode().strip()}",
#                         f"returncode = {process.returncode}")


# def detect_workspaces(stack_paths: List[str]) -> List[str]:
#     workspaces = []
#     for stack_path in stack_paths:
#         workspaces.append(get_stack_name(Path(stack_path)))
#     return list(set(filter(None, workspaces)))


def get_stack_name(stack_dir: Path) -> str:
    yaml_content = read_to_yaml(str(stack_dir / STACK_FILE))
    return yaml_content.get(NAME) or ""


def read_to_yaml(file_path):
    with open(file_path) as file:
        # The FullLoader parameter handles the conversion from YAML
        # scalar values to Python the dictionary format
        # See: https://github.com/yaml/pyyaml/wiki/PyYAML-yaml.load(input)-Deprecation#how-to-disable-the-warning
        return yaml.load(file, Loader=yaml.FullLoader)


def get_workspace_file_dir() -> str:
    return os.getenv(WORKSPACE_FILE_DIR) or "workspaces"


def workspace_file_path(file_dir: str, name: str) -> str:
    file = name + YAML_FILE_SUFFIX
    return os.path.join(file_dir, file)
