import os
from .common import *
from pathlib import Path
from typing import List, Union
import requests
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


def get_changed_files_from_oss(change_paths_url):
    """从OSS获取文件变更列表"""
    times = 0  # 重试计数
    while times < RETRY_MAX_NUM:
        try:
            down_res = requests.get(change_paths_url)
            if not down_res:
                raise Exception(f"Empty down resource: {down_res}")
            down_res_content = down_res.content
            if not down_res_content:
                raise Exception(f"Empty down resource content: {down_res_content}")
            change_paths_str = down_res_content.decode()
            break
        except Exception as e:
            times += 1
            if times >= RETRY_MAX_NUM:
                print(f">> Exceed maximal retry {RETRY_MAX_NUM}, Raise exception...")
                raise (e)  # will stop the program without further handling
            else:
                time.sleep(RETRY_INTERVAL)
                print(f">> Exception, Retry {times} begins...")
    return change_paths_str


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


def filter_project_dir() -> List[Path]:
    """
    filter the project_dirs by $CHANGED_FILE_URL and $IGNORE_PATHS, only changed project will be reserved.
    $CHANGED_FILE_URL:
        string type.
        the url contains a changed_file.txt file and the file's content is changed file paths separated by newline.
        passed from env variable $CHANGED_FILE_URL
    $IGNORE_PATHS:
        ignore_paths_str: string type.
        paths to ignore separated by ','. the path to ignore should be project level directory or higher.
        passed from env variable IGNORE_PATHS
    :return: the filtered dirs
    """
    all_project_dirs = get_konfig_projects_relative()
    # use string output directly
    change_file = os.getenv("CHANGED_FILE")
    ignore_paths_str = os.getenv("IGNORE_PATHS")
    mode_filter = os.getenv("KCL_TEST_MODE")

    if mode_filter != "biz":
        # when KCL_TEST_MODE is 'base', all test cases under Konfig/sigma will be tested
        change_paths = all_project_dirs
    else:
        # change_paths_str = get_changed_files_from_oss(change_paths_url)
        change_paths_str = change_file
        print(f"Change Path: {change_paths_str}")
        if change_paths_str == EMPTY_CHANGE_LIST or not change_paths_str:
            return []
        if change_paths_str == TRIGGER_ALL_TEST:
            # when change_paths' content is zz_all_test, all test cases under Konfig/sigma will be tested
            change_paths = all_project_dirs
        else:
            # when KCL_TEST_MODE is 'biz', only cases under specified root dir will be tested
            change_paths = [item[1:-1] for item in change_paths_str.split(" ") if item]
    ignore_path_list = []
    if ignore_paths_str:
        ignore_path_list = [item for item in ignore_paths_str.split(",") if item]
    changed_projects = []
    for change_path in change_paths:
        if any(
            [
                check_path_is_relative_to(change_path, ignore_path)
                for ignore_path in ignore_path_list
            ]
        ):
            continue
        for project_path in all_project_dirs:
            if (
                check_path_is_relative_to(change_path, project_path)
                and project_path not in changed_projects
            ):
                changed_projects.append(project_path)
    return changed_projects


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
