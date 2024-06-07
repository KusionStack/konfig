import os
from pathlib import Path
from typing import List
from lib.common import *
from lib import util


def split_changed_paths_str(changed_paths_str: str) -> List[str]:
    # output "diff" of technote-space/get-diff-action@v6 has '', should remove it
    # ref: https://github.com/technote-space/get-diff-action/blob/v6/README.md
    return [item[1:-1] for item in changed_paths_str.split(" ") if item]


def get_changed_project_paths(changed_paths: List[str]) -> List[str]:
    project_paths = []
    check_files = [KCL_FILE_SUFFIX, KCL_MOD_FILE, PROJECT_FILE, STACK_FILE]
    for changed_path in changed_paths:
        if not changed_path:
            continue
        # ignore if not .k file or kcl.mod/kcl.mod.lock/stack.yaml/project.yaml
        if not exist_suffix(check_files, changed_path):
            continue
        # if the project has already detected, skip it
        if exist_prefix(project_paths, changed_path):
            continue

        # find nearest dir contains project.yaml
        path = find_nearest_dir_contains_file(changed_path, PROJECT_FILE)
        if path:
            project_paths.append(path)
    return project_paths


def get_changed_stack_paths(changed_paths: List[str], project_paths: List[str]) -> List[str]:
    stack_paths = []
    check_files = [KCL_FILE_SUFFIX, KCL_MOD_FILE, PROJECT_FILE, STACK_FILE]
    for changed_path in changed_paths:
        if not changed_path:
            continue
        # ignore if not .k file or kcl.mod/kcl.mod.lock/stack.yaml/project.yaml
        if not exist_suffix(check_files, changed_path):
            continue
        # if the stack has already detected, skip it
        if exist_prefix(stack_paths, changed_path):
            continue
        # if the changed_path is a project's base/base.k or project.yaml, then all the stacks get changed
        is_base_file = False
        for project_path in project_paths:
            if changed_path == project_path + "/" + BASE_FILE or changed_path == project_path + "/" + PROJECT_FILE:
                is_base_file = True
                stacks = util.detect_all_stacks(project_path)
                stack_paths = append_if(stack_paths, stacks)
                break
        if is_base_file:
            continue

        # find nearest dir contains stack.yaml
        path = find_nearest_dir_contains_file(changed_path, STACK_FILE)
        if path:
            stack_paths.append(path)
    return stack_paths


def exist_prefix(lists: List[str], s: str) -> bool:
    for item in lists:
        if s.startswith(item):
            return True
    return False


def exist_suffix(lists: List[str], s: str) -> bool:
    for item in lists:
        if s.endswith(item):
            return True
    return False


# todo: "/" does not work under windows, should upgrade it
def find_nearest_dir_contains_file(path: str, file: str) -> str:
    splits = path.split("/")
    for index in range(len(splits) - 1):
        path = path.rsplit("/", 1)[0]
        if not path:
            continue
        if exist_file(path, file):
            return path
    return ""


def exist_file(path: str, file_name: str) -> bool:
    dir_path = Path(path)
    if dir_path.exists():
        for filename in os.listdir(path):
            if filename == file_name:
                return True
    return False


def append_if(l1: List[str], l2: List[str]) -> List[str]:
    l3 = l1
    for item2 in l2:
        equal = False
        for item1 in l1:
            if item2 == item1:
                equal = True
                break
        if not equal:
            l3.append(item2)
    return l3


changed_paths_str = os.getenv(CHANGED_PATHS)
changed_paths = split_changed_paths_str(changed_paths_str)
changed_projects = get_changed_project_paths(changed_paths)
changed_stacks = get_changed_stack_paths(changed_paths, changed_projects)
changed_projects_str = util.merge_list_to_str(changed_projects)
changed_stacks_str = util.merge_list_to_str(changed_stacks)
# "set-output" is getting deprecated, update it
# ref: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
#      https://github.com/orgs/community/discussions/28146
with open(os.environ[GITHUB_OUTPUT], 'a') as fh:
    print(f'changed_projects={changed_projects_str}', file=fh)
    print(f'changed_stacks={changed_stacks_str}', file=fh)