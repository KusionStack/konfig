"""
Let compile take off 🚀
"""
import os
import sys
import time
import yaml
import toml
import logging
import subprocess
from threading import Thread, BoundedSemaphore
from pathlib import Path
from lib.common import *
from lib import utils
from packaging import version

# 最大线程数
MAX_THREADING_NUM = 5
max_threading_control = BoundedSemaphore(MAX_THREADING_NUM)
# 是否输出编译开始提示
IS_OUTPUT_ENV_COMPILE_INFO = False

# 初始化色彩
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
BOLD = "\033[1m"
RESET = "\033[m"

try:
    TERMINAL_WIDTH = os.get_terminal_size().columns
except Exception as e:
    TERMINAL_WIDTH = 64

COMPILE_COMMAND = [
    "kusion",
    "compile",
    "-Y",
    "ci-test/settings.yaml,kcl.yaml",
    "-o",
    "ci-test/stdout.golden.yaml",
]

# 应用和线程的映射关系
app_to_threads = dict()
# 应用和该应用下所有 Env 目录的映射关系
app_to_envpaths = dict()
# 记录每个 Env 目录的 make 任务的执行结果：None 表示任务还未执行完，True 表示任务执行成功，False 表示任务执行失败
envpath_to_result = dict()
# 记录每个 App 是否执行结束，该 App 下所有 Env 的任务都执行完毕（不管成功/失败），那么认为该应用执行完毕
app_to_isfinish = dict()


def put(d: dict, key: str, value: Thread):
    """将指定元素作为数组元素 put 到 dict[key] 中"""
    if d.get(key) is None:
        d[key] = []
    d[key].append(value)


def pretty_print(app_path: str):
    """命令行可视化输出"""
    print(
        f"{GREEN}{app_path}{RESET}",
        f"{BOLD}{GREEN}[ALL DONE]{RESET}".rjust(
            TERMINAL_WIDTH * 2 // 3 - len(app_path)
        ),
        flush=True,
    )
    env_paths = app_to_envpaths[app_path]
    for i, env_path in enumerate(env_paths):
        if i < len(env_paths) - 1:
            env_info = f"  ┣━ {env_path}"
        else:
            env_info = f"  ┗━ {env_path}"
        if envpath_to_result[env_path]:
            print(
                f"{GREEN}{env_info}{RESET}",
                f"{BOLD}{GREEN}[Success]{RESET}".rjust(
                    TERMINAL_WIDTH * 2 // 3 - len(env_info)
                ),
                flush=True,
            )
        else:
            print(
                f"{GREEN}{env_info}{RESET}",
                f"{BOLD}{RED}[Failed]{RESET}".rjust(
                    TERMINAL_WIDTH * 2 // 3 - len(env_info)
                ),
                flush=True,
            )


def check_app_finish(app_path: str, threads: Thread) -> bool:
    """检查该应用的所有任务是否执行完成"""
    # 统计该应用每个环境的任务的执行结果
    # None 表示任务还未执行完，True 表示任务执行成功，False 表示任务执行失败
    env_task_results = []
    for env_path in app_to_envpaths.get(app_path):
        env_task_results.append(envpath_to_result[env_path])
    # 如果该应用的每个环境的编译任务都完成（不管执行失败/成功），那么整个应用的编译任务完成，否则应用的编译任务未完成
    if all(map(lambda result: result is not None, env_task_results)):
        if app_to_isfinish.get(app_path) is None:
            # 应用任务刚完成时，输出提示信息
            pretty_print(app_path)
            app_to_isfinish[app_path] = True
        return True
    else:
        return False


def run_task(app_path: str, env_path: str):
    """启动一个线程任务"""
    if (
        app_to_envpaths.get(str(app_path)) is None
        or str(env_path) not in app_to_envpaths[str(app_path)]
    ):
        thread = Thread(target=task, args=(env_path,))
        put(app_to_threads, str(app_path), thread)
        put(app_to_envpaths, str(app_path), str(env_path))
        envpath_to_result[str(env_path)] = None
        thread.start()


def run_task_by_app_path(app_path: Path):
    """启动应用目录下的所有线程任务"""
    if utils.is_stack_dir(app_path):
        run_task(app_path.parent, app_path)
    elif utils.is_project_dir(app_path):
        for env_path in app_path.iterdir():
            # 判断是否为 Env 目录
            if utils.is_stack_dir(env_path):
                # 并发启动该应用每个 Env 目录下的 make 编译
                run_task(app_path, env_path)


def task(env_path: Path):
    """线程任务"""
    with max_threading_control:
        try:
            if IS_OUTPUT_ENV_COMPILE_INFO:
                print(f"{GREEN}Compiling in {env_path} ...{RESET}", flush=True)
            # 前置校验
            ci_test_dir = env_path / CI_TEST_DIR
            if not ci_test_dir.is_dir():
                raise Exception(f"missing ci-test dir in env dir [{env_path}]")
            # 构造命令
            command = []
            exec_workspace = None
            if (env_path / KCL_FILE).is_file() and (
                ci_test_dir / SETTINGS_FILE
            ).is_file():
                command = COMPILE_COMMAND
                exec_workspace = env_path.absolute()
            else:
                raise Exception(f"failed to construct command in env dir [{env_path}]")
            # 执行命令
            process = subprocess.run(
                command, capture_output=True, cwd=exec_workspace, env=dict(os.environ)
            )
            # 任务结束，输出提示信息
            stdout, stderr = process.stdout, process.stderr
            if stdout.decode().strip() != "":
                print(stdout.decode().strip(), flush=True)
            if process.returncode != 0 or len(stderr) != 0:
                raise Exception(stderr.decode().strip(), process.returncode)
        except Exception as e:
            # 上述运行过程出现异常，任务执行失败，输出提示信息
            envpath_to_result[str(env_path)] = False
            if len(e.args) == 1:
                print(
                    f"\n{BOLD}{RED}[Error]{RESET} {RED}Failed to compile in [{env_path}] {RESET}\nstderr = {e.args[0]}\n",
                    flush=True,
                )
            elif len(e.args) == 2:
                print(
                    f"\n{BOLD}{RED}[Error]{RESET} {RED}Failed to compile in [{env_path}] {RESET}\nexit code = {e.args[1]}\nstderr = {e.args[0]}\n",
                    flush=True,
                )
        else:
            # 上述运行过程没有出现异常，任务执行成功
            envpath_to_result[str(env_path)] = True


def print_statistics(start_time: float):
    """输出统计信息"""
    total_app_num = len(app_to_threads.keys())
    total_env_num = sum(list(map(len, list(app_to_envpaths.values()))))
    assert total_app_num > 0, "no application directory available"
    assert total_env_num > 0, "no env directory available"
    # 统计失败任务
    failed_apps = []
    failed_app_envs = []
    for app_path, env_paths in app_to_envpaths.items():
        for env_path in env_paths:
            if not envpath_to_result[env_path]:
                failed_app_envs.append(env_path)
        if len(failed_app_envs) > 0:
            failed_apps.append(app_path)
    # 输出失败任务
    if len(failed_app_envs) > 0:
        print(f"{BOLD}{RED}")
        print(f"Failed path:")
        for app_env in failed_app_envs:
            print(f"- {app_env}")
        print(f"{RESET}", end="")
    # 输出时间统计信息
    end_time = time.time()
    spend_time = end_time - start_time
    if len(failed_app_envs) == 0:
        print(f"\n{BOLD}{GREEN}All Success!{RESET}")
    else:
        print(
            f"\n{BOLD}{GREEN}Successful/Failed app: {total_app_num - len(failed_apps)}/{RED}{len(failed_apps)}{RESET}{BOLD}{GREEN}, Successful/Failed path: {total_env_num - len(failed_app_envs)}/{RED}{len(failed_app_envs)}{RESET}"
        )
    print(
        f"{BOLD}{GREEN}Total time: {spend_time:.2f}s, Total app num: {total_app_num}, Total env num: {total_env_num}, Time per env: {(spend_time/total_env_num):.2f}s{RESET}\n",
        flush=True,
    )
    if len(failed_app_envs) == 0:
        sys.exit(0)
    else:
        sys.exit(1)


def find_app_paths(cur_path: Path):
    if not cur_path.is_dir():
        return []
    if utils.is_project_dir(cur_path) or utils.is_stack_dir(cur_path):
        return [cur_path]
    result = []
    for per_path in cur_path.iterdir():
        result += find_app_paths(per_path)
    return result


def loadKclModConfig(root: Path) -> dict:
    k_mod_file_path = str(root / KCLMOD_FILE)
    if not os.path.exists(k_mod_file_path):
        return {}
    return toml.load(k_mod_file_path)


def validate_expected():
    try:
        KUSION_UPDATE_NOTICE = (
            f"""{BOLD}{RED}WARN{RESET}: {RED}您的本地 kusion 版本需要升级，否则可能会导致本地编译失败"""
        )

        # Parse kcl.mod
        kclmodConfig = loadKclModConfig(utils.get_konfig_root())
        exceptedConfig = kclmodConfig.get("expected", {})

        # Get expected config from kcl.mod
        min_kclvm_version = exceptedConfig.get("kclvm_version", "v0.0.1")
        min_kcl_plugin_version = exceptedConfig.get("kcl_plugin_version", "v0.0.1")

        # Get current config from kusion version
        exitcode, out = subprocess.getstatusoutput("kusion version")
        if exitcode != 0:
            print(KUSION_UPDATE_NOTICE + "\n")
            return
        versionInfo = yaml.safe_load(out, Loader=yaml.FullLoader)
        dependency = versionInfo.get("dependency", {})
        current_kclvm_version = dependency.get("kclvmVersion", "v0.0.0")
        current_kcl_plugin_version = dependency.get("kclPluginVersion", "v0.0.0")

        # Validate
        if not (
            version.parse(min_kclvm_version) <= version.parse(current_kclvm_version)
        ) or not (
            version.parse(min_kcl_plugin_version)
            <= version.parse(current_kcl_plugin_version)
        ):
            print(KUSION_UPDATE_NOTICE)
            # print(f"      {RED}本地 kusion 版本: \n{out}{RESET}\n")
    except Exception as e:
        print("WARN: " + str(e))
    return


if __name__ == "__main__":
    # 前置任务：检查当前 kusion 版本是否符合大库预期
    # validate_expected()
    # 没有传入任何应用目录
    if len(sys.argv) == 1:
        logging.warning("please give the project paths")
        sys.exit(0)
    # 遍历处理每个应用目录
    start_time = time.time()
    app_paths = sys.argv[1:]
    for app_path_str in app_paths:
        app_path = Path(app_path_str)
        # 根据关键字搜索大库匹配的目录作为应用目录
        glob_root = utils.get_konfig_root()
        if app_path_str == "all":
            app_path_str = ""
        glob_paths = (
            set(glob_root.glob(f"**/{app_path_str}"))
            - set((glob_root / ".git").glob("**"))
            - set((glob_root / ".kclvm").glob("**"))
        )
        glob_paths_str = list(set(list(map(lambda x: str(x), glob_paths))))
        print(
            f"{GREEN}{BOLD}Matched path{BOLD}{RESET}{GREEN}: {glob_paths_str}{RESET}",
            flush=True,
        )
        print(
            f"{GREEN}{BOLD}Matched path total{BOLD}{RESET}{GREEN}: {len(glob_paths_str)}{RESET}\n",
            flush=True,
        )
        glob_app_paths = []
        for glob_path in glob_paths:
            glob_app_paths += find_app_paths(glob_path)
        for glob_app_path in glob_app_paths:
            run_task_by_app_path(glob_app_path)

    # 成组（以应用为单位）输出并发执行结果，防止输出混乱
    while True:
        # 所有应用都运行完毕，结束程序
        if all(
            map(
                check_app_finish,
                list(app_to_threads.keys()),
                list(app_to_threads.values()),
            )
        ):
            break
        time.sleep(1)
    # 输出统计信息
    print_statistics(start_time)
