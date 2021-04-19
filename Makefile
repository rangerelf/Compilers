.PHONY: help nim

help: ## Display this help message
	@echo "Usage:"
	@sed -En 's!^([a-z][^:]+):.+?##(.+)$$!\tmake \1\t- \2!p' $(MAKEFILE_LIST)

nim: ## Build nim compiler image
	docker build -t nim:local Nim

