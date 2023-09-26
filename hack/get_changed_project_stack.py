import os
from pathlib import Path
from typing import List
from lib.common import *
from lib import util


def split_changed_paths_str(changed_paths_str: str) -> List[str]:
    # output "diff" of technote-space/get-diff-action@v6 has '', should remove it
    # ref: https://github.com/technote-space/get-diff-action/blob/v6/README.md
    return [item[1:-1] for item in changed_paths_str.split(" ") if item]


def get_changed_project_stack_paths(changed_paths: List[str], identification_file: str) -> List[str]:
    project_stack_paths = []
    check_files = [KCL_MOD_FILE, KCL_MOD_LOCK_FILE, PROJECT_FILE, STACK_FILE]
    for changed_path in changed_paths:
        if not changed_path:
            continue
        # ignore if not .k file or kcl.mod/kcl.mod.lock/project.yaml/stack.yaml
        elif not changed_path.endswith(KCL_FILE_SUFFIX) and not exist_str(check_files, changed_path):
            continue
        # if the project or stack has already detected, skip it
        elif exist_suffix(project_stack_paths, changed_path):
            continue

        # find nearest identification_file, i.e. project.yaml or stack.yaml
        # todo: "/" does not work under windows, should upgrade it
        splits = changed_path.split("/")
        path = changed_path
        for index in range(len(splits) - 1):
            path = path.rsplit("/", 1)[0]
            if not path:
                continue
            if exist_file(path, identification_file):
                project_stack_paths.append(path)
                break
    return project_stack_paths


def exist_str(lists: List[str], s: str) -> bool:
    for item in lists:
        if item == s:
            return True
    return False


def exist_suffix(lists: List[str], s: str) -> bool:
    for item in lists:
        if s.startswith(item):
            return True
    return False


def exist_file(path: str, file_name: str) -> bool:
    dir_path = Path(path)
    if dir_path.exists():
        for filename in os.listdir(path):
            if filename == file_name:
                return True
    return False


changed_paths_str = os.getenv(CHANGED_PATHS) or STUB_CASE
changed_paths = split_changed_paths_str(changed_paths_str)
changed_projects = get_changed_project_stack_paths(changed_paths, PROJECT_FILE)
changed_stacks = get_changed_project_stack_paths(changed_paths, STACK_FILE)
changed_projects_str = util.merge_list_to_str(changed_projects)
changed_stacks_str = util.merge_list_to_str(changed_stacks)
# "set-output" is getting deprecated, update it
# ref: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
#      https://github.com/orgs/community/discussions/28146
with open(os.environ[GITHUB_OUTPUT], 'a') as fh:
    print(f'changed_projects={changed_projects_str}', file=fh)
    print(f'changed_stacks={changed_stacks_str}', file=fh)
