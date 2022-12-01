import os
from .common import *
from pathlib import Path
from typing import List, Union
import time

RETRY_MAX_NUM = os.getenv("RETRY_MAX_NUM", 5)  # 最大重试次数（默认五次）
RETRY_INTERVAL = os.getenv("RETRY_INTERVAL", 3)  # 重试间隔时间（默认3秒）


def startswith(p: Path, start: Path) -> bool:
    try:
        p.relative_to(str(start.resolve()))
        return True
    except Exception as e:
        return False


def get_project_root(p: Path) -> Path:
    """获取 Project 根目录"""
    while str(p.resolve()) != "/":
        if is_project_dir(p):
            return p
        p = p.resolve().parent
    return None


def get_konfig_root() -> Path:
    """获取大库根目录"""
    p = Path(os.getcwd())
    while str(p.resolve()) != "/":
        if (p / KCLMOD_FILE).is_file() and (p / HACK_DIR).is_dir():
            return p
        p = p.resolve().parent
    return Path(os.getcwd())


def get_konfig_projects() -> List[Path]:
    """获取大库所有 project 目录"""
    result = []
    for project_dir, _, _ in os.walk(get_konfig_root()):
        project_dir = Path(project_dir)
        if is_project_dir(project_dir):
            result.append(project_dir)
    return result


def get_konfig_projects_relative() -> List[Path]:
    """获取大库所有 project 相对于根目录的路径"""
    project_dirs = get_konfig_projects()
    konfig_root = get_konfig_root()
    return [item.relative_to(konfig_root) for item in project_dirs]


def is_project_dir(p: Path) -> bool:
    """当前目录是否为项目目录"""
    project_file = p / PROJECT_FILE
    return project_file.is_file()


def is_stack_dir(p: Path) -> bool:
    """当前目录是否为 Stack 目录"""
    stack_file = p / STACK_FILE
    return stack_file.is_file()


def has_settings_file(path: Path) -> bool:
    """当前目录是否包含 settings 文件"""
    settings_file = path / SETTINGS_FILE
    return settings_file.is_file()


def check_path_is_relative_to(path_a: Union[str, Path], path_b: Union[str, Path]):
    """
    check if path_a is relative to path_b.
    Here are some examples:
    path_a: Path('/etc/passwd/') path_b: Path('/etc')    True
    path_a: Path('/etc/')        path_b: Path('/etc')    True
    path_a: Path('/etc/a/b/c')   path_b: Path('/etc')    True
    path_a: Path('/usr/')        path_b: Path('/etc')    False

    :param path_a: string type or pathlib.Path type.
    :param path_b: string type or pathlib.Path type.
    :return: if path_a is relative to path_b.
    """
    return Path(path_b) in [p for p in Path(path_a).parents] + [Path(path_a)]


def get_affected_projects() -> List[str]:
    affected_projects_str = os.getenv("AFFECTED_PROJECTS") or ""
    return [project for project in affected_projects_str.split("\n") if project]


def get_affected_stacks() -> List[str]:
    affected_stacks_str = os.getenv("AFFECTED_STACKS") or ""
    return [stack for stack in affected_stacks_str.split("\n") if stack]


def get_stack_files_paths_from_change_paths(change_paths_str):
    stack_path_list = []
    changed_filepath_list = [item[1:-1] for item in change_paths_str.split(" ") if item]
    for filepath in changed_filepath_list:
        if not filepath:
            continue
        elif not filepath.endswith("stdout.golden.yaml"):
            continue
        # find nearest stack.yaml
        splits = filepath.split("/")
        path = filepath
        for index in range(len(splits) - 1):
            path = path.rsplit("/", 1)[0]
            if not path:
                continue
            if path and find_in_dirs(path, "stack.yaml"):
                if path not in stack_path_list:
                    stack_path_list.append(path)
                break
    return stack_path_list


def find_in_dirs(path, file_name):
    dir_path = Path(path)
    if dir_path.exists():
        for filename in os.listdir(path):
            if filename.lower() == file_name:
                stack_path = os.path.join(path, filename)
                print("find " + stack_path)
                return stack_path
    return ""
