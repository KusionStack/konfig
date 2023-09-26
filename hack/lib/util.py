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


# there are some examples cannot get compiled and applied correctly
def should_ignore_stack(stack_dir: str) -> bool:
    for project_dir in IGNORE_PROJECTS:
        if stack_dir.startswith(project_dir):
            return True
    return False
