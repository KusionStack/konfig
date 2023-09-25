import os
import pytest
from pathlib import Path
from test_konfig import test_dirs

KCL_FILE_SUFFIX = ".k"
LINT_LEN = 200


@pytest.mark.parametrize("test_dir", test_dirs)
def test_lint(test_dir):
    for root, dirs, files in os.walk(test_dir):
        for file in files:
            if not file.endswith(KCL_FILE_SUFFIX):
                continue
            file_path = root + os.path.sep + file
            line_index = 0
            for line in open(file_path):
                line_index = line_index + 1
                line = line.replace("\n", "")
                line_len = len(line)
                if line_len <= LINT_LEN:
                    continue
                assert (
                    False
                ), f"KCL line len exceed: {Path(file_path).absolute()}:{line_index}. limit: {LINT_LEN}, actual: {line_len})"
