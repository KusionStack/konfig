import os
import subprocess
from concurrent.futures import ThreadPoolExecutor


def run_kcl_command(path):
    """
    Executes the kcl run command
    """
    print(f"Running 'kcl run' in {path}...")
    result = subprocess.run(["kcl", "run"], cwd=path, capture_output=True, text=True)
    if result.stderr:
        print(f"Error running 'kcl run' in {path}: {result.stderr}")
    else:
        print(f"Output from running 'kcl run' in {path}: {result.stdout}")


def find_and_run_kcl(paths_list):
    """
    Concurrently executes the kcl run command in paths containing kcl.mod
    """
    with ThreadPoolExecutor() as executor:
        executor.map(run_kcl_command, paths_list)


def find_kcl_mod_files(directory):
    """
    Recursively searches for paths containing the kcl.mod file
    """
    paths_with_kcl_mod = []
    for root, dirs, files in os.walk(directory):
        if "kcl.mod" in files:
            paths_with_kcl_mod.append(root)
    return paths_with_kcl_mod


def main():
    examples_dir = "examples"  # Set the path of the examples folder
    paths_with_kcl_mod = find_kcl_mod_files(examples_dir)
    if paths_with_kcl_mod:
        print(f"Found {len(paths_with_kcl_mod)} paths with 'kcl.mod'.")
        find_and_run_kcl(paths_with_kcl_mod)
    else:
        print("No 'kcl.mod' files found in the directory.")


if __name__ == "__main__":
    main()
