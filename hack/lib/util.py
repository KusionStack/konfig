import os
from typing import List
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
