.PHONY: init shell nuke nuke-force

PROJECT_NAME := $(shell basename $(shell pwd))
HASH := $(shell echo -n "$(shell pwd)" | shasum | cut -c1-4)
CONTAINER_NAME := sc-$(PROJECT_NAME)-$(HASH)

init:
	@./init.sh

nuke:
	@echo "Destroying container $(CONTAINER_NAME)..."
	@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@docker volume rm vscode 2>/dev/null || true
	@echo ""
	@sh -c ' \
		GIT_STATUS="$$(git status --short)"; \
		printf "%s\n" "$$GIT_STATUS"; \
		if [ -n "$$GIT_STATUS" ]; then \
			echo ""; \
			echo "WARNING: Git workspace is not clean."; \
			echo "Run make nuke-force to discard all changes and reset."; \
		fi \
	'
	@echo "Done."

nuke-force:
	@echo "Resetting git workspace..."
	@git reset --hard
	@git clean -fd
	@echo "Destroying container $(CONTAINER_NAME)..."
	@docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@docker volume rm vscode 2>/dev/null || true
	@echo "Done."
