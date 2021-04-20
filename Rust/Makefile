.PHONY: help install uninstall


RUSTC		:= ~/.cargo/bin/rustc
RUST_HOME	:= https://www.rust-lang.org/
RUST_VERSION	:= $(shell [ -x $(RUSTC) ] && $(RUSTC) --version | awk '{print $$2}' || echo 'N/A')
RUST_UPSTREAM	:= $(shell curl -Ls $(RUST_HOME) | grep -Eo 'Version\s*[0-9]+(\.[0-9]+)+' | head -1 | awk '{print $$2}')

RUSTUP_INIT_SH	:= rustup-init.sh
RUSTUP_INIT_URL	:= https://sh.rustup.sh

help: ## Display this help message
	@echo "Installed: $(RUST_VERSION)"
	@echo "Upstream: $(RUST_UPSTREAM)"
	@echo ""
	@echo "Usage:"
	@sed -nE 's|^([a-z][^:]+):.+?##\s*(.+)\s*$$|\tmake \1\t- \2|p' $(MAKEFILE_LIST)

install: $(RUSTUP_INIT_SH) ## Install 'rustup' installer
	sh $<

uninstall: ## Remove installed Rust packages
	-rm -rf ~/.rustup
	@echo "Not removing ~/.cargo because it might have built packages"

uninst-all: ## Remove everything
	-rm -rf ~/.rustup ~/.cargo

$(RUSTUP_INIT_SH):
	curl -sSf $(RUSTUP_INIT_URL) -o $@

# vim:ai:noet:ts=8:wm=0:
