#!/bin/sh

# Stop on error.

# Note: Before you start tests, please install kcl and kpm
# kcl installation: https://kcl-lang.io/docs/user_docs/getting-started/install
# kpm Installation: https://kcl-lang.io/docs/user_docs/guides/package-management/installation

set -e

find ./examples -name "kcl.mod" -exec dirname {} \; | while read -r dir; do
    if (cd "$dir" && kpm run); then
        echo "\033[32mTest SUCCESSED - $dir\033[0m\n"
    else
        echo "\033[31mTest FAILED - $dir\033[0m\n"
        exit 1
    fi
done
