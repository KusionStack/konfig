PWD=$(shell pwd)
PROJECT_NAME=Konfig
KUSION_IMAGE=kusionstack/kusion:latest

parallel-compile=kclvm hack/compile-rocket.py

help:  ## 这里是帮助文档 :)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-sh:  ## 在 kusion docker 容器中执行 shell
	docker run --rm -v $(PWD):/${PROJECT_NAME} -w /${PROJECT_NAME} -it -u root ${KUSION_IMAGE}

check-all:  ## 校验所有 Project
	@${parallel-compile} all

check-%: ## 检验指定目录下的 Project
	@${parallel-compile} $*

# Build and run tests.
#
# Args:
#   WHAT: Project directory names to test.
#
# Example:
#   make check WHAT=cafeextcontroller
#   make check WHAT="cafeextcontroller infraform"
#   make check WHAT=samples
check:  ## 校验指定目录下的 Project，比如 make check WHAT=nginx-example 或者 make check WHAT="http-echo nginx-example"
	@${parallel-compile} $(WHAT)

clean-all:  ## 清理缓存
	@echo "cleaning kcl cache..."
	@rm -rf ./.kclvm
	@echo "cleaning test cache..."
	@find . -name .pytest_cache  | xargs rm -rf
	@echo "clean finished."

install-hooks:  ## 安装 git hooks，目前主要有 pre-commit hook（提交时自动编译）
	@rm -rf .git/hooks/pre-commit
	@cd .git/hooks && ln -s ../../hooks/pre-commit pre-commit
	@echo 'Successfully install pre-commit hooks!'

uninstall-hooks:  ## 卸载 git hooks
	@rm -rf .git/hooks/pre-commit
	@echo 'Successfully uninstall pre-commit hooks!'
