.PHONY: init shell nuke

init:
	@./init.sh

shell:
	@echo "Opening VS Code..."
	@code .

nuke:
	@echo "Destroying devcontainer..."
	@docker ps -q -f "label=devcontainer.local_folder=$(shell pwd)" | while read cid; do \
		[ -n "$$cid" ] && docker rm -f $$cid; \
	done
	@docker system prune -f >/dev/null 2>&1 || true
	@echo "Done."
