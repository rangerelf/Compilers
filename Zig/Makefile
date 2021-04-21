.PHONY: help inst-latest inst-master uninstall

INSTPREFIX	?= ${HOME}/.local
INSTDIR		?= $(INSTPREFIX)/zig

## Some MUSL definitions
ZIG_HOME	:= https://ziglang.org/download/
crx		 = $(shell curl -Ls $(ZIG_HOME) | grep -Eo 'zig-linux-x86_64-[0-9]+(\.[0-9]+)+$1\.tar\.xz' | head -1)
cln		 = $(shell echo "$1" | sed -e 's/^zig-linux-x86_64-//g' -e 's/\.tar\.xz$$//g')
url		 = $(shell curl -Ls $(ZIG_HOME) | grep -o '=[^<>]*zig-linux-x86_64-$1\.tar\.xz' | head -1 | cut -d= -f2-)
ZIG_INSTALLED	:= $(shell bash -c 'type -p zig >/dev/null' && zig version || echo "N/A")
ZIG_MASTER_TXZ	:= $(call crx,-dev.[0-9]+\+[0-9a-f]+)
ZIG_LATEST_TXZ	:= $(call crx,)
ZIG_MASTER	:= $(call cln,$(ZIG_MASTER_TXZ))
ZIG_LATEST	:= $(call cln,$(ZIG_LATEST_TXZ))

help: ## Display this help message
	@echo "Installed: $(ZIG_INSTALLED)"
	@echo "Master: $(ZIG_MASTER)"
	@echo "Latest: $(ZIG_LATEST)"
	@echo ""
	@echo "Usage:"
	@sed -nE 's|^([a-z][^:]*):.+?##\s+(.+)\s*$$|\tmake \1\t- \2|p' $(MAKEFILE_LIST)

uninstall: ## Remove installed nim & musl
	-rm -rf $(INSTDIR)

latest: zig-docs ## Install latest version
	@curl -Lsf $(call url,$(ZIG_LATEST)) | pv | tar xJ --strip-components=1 -C $(INSTDIR)

master: zig-docs ## Install current dev release
	@curl -Lsf $(call url,$(ZIG_MASTER)) | pv | tar xJ --strip-components=1 -C $(INSTDIR)

zig-docs:
	@mkdir -p $(INSTDIR)
	@printf '#!/bin/sh\nexec links ~/.local/zig/docs/langref.html\n' > $(INSTDIR)/zig-docs
	@chmod 755 $(INSTDIR)/zig-docs

