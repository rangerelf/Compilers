.PHONY: help clean build install uninstall

INSTPREFIX	?= ${HOME}/.local
INSTDIR		?= $(INSTPREFIX)/nim

## Some functions to fetch remote version
latest_tag = $(shell git ls-remote --tags $1 | sed -nE 's|^.*/v([0-9]+(\.[0-9]+)+)$$|\1|p' | sort -V | tail -1)
inst_ver   = $(shell [ -f $1 ] && grep -Eo '[0-9]+(\.[0-9]+)+' $1 || echo 'N/A')

## Some MUSL definitions
MUSL_REPO	:= git://git.musl-libc.org/musl
MUSL_UPSTREAM	:= $(call latest_tag,$(MUSL_REPO))
MUSL_VERSION_F	:= $(INSTDIR)/.musl.version
MUSL_INSTALLED	:= $(call inst_ver,$(MUSL_VERSION_F))
MUSL_BUILT	:= src/musl/lib/libc.a
MUSL_UNPACKED	:= src/musl/configure

## Some Nim definitions
NIM_REPO	:= https://github.com/nim-lang/Nim
NIM_UPSTREAM	:= $(call latest_tag,$(NIM_REPO))
NIM_VERSION_F	:= $(INSTDIR)/.nim.version
NIM_INSTALLED	:= $(call inst_ver,$(NIM_VERSION_F))
NIM_ARCHIVE	:= nim-$(NIM_UPSTREAM).tar.xz
NIM_URL		:= https://nim-lang.org/download/$(NIM_ARCHIVE)
NIM_BUILT	:= src/nim/bin/nim
NIM_UNPACKED	:= src/nim/makefile

## Number of parallel jobs
JOBS	:= $(shell grep ^processor /proc/cpuinfo | wc -l)

help: ## Display this help message
	@echo "Nim: $(NIM_INSTALLED) [upstream: $(NIM_UPSTREAM)]"
	@echo "MUSL LibC: $(MUSL_INSTALLED) [upstream: $(MUSL_UPSTREAM)]"
	@echo ""
	@echo "Usage:"
	@sed -nE 's|^([a-z][^:]*):.+?##\s+(.+)\s*$$|\tmake \1\t- \2|p' $(MAKEFILE_LIST)

clean: ## Clear out all work data
	-rm -rf src/musl src/nim

clean-all: ## Delete all downloaded data too
	-rm -rf src

uninstall: ## Remove installed nim & musl
	-rm -rf $(INSTDIR)

build: musl nim ## Build musl and nim binaries

nim: $(NIM_BUILT)

musl: $(MUSL_BUILT)

$(NIM_BUILT): $(NIM_UNPACKED)
	cd src/nim \
	  && make -f ./makefile -j $(JOBS) \
	  && ./bin/nim c -d:release --opt:speed koch.nim \
	  && ./koch tools

$(MUSL_BUILT): $(MUSL_UNPACKED)
	cd src/musl \
	  && ./configure --prefix=$(INSTDIR) --enable-optimize=size --disable-shared --enable-static --enable-wrapper \
	  && make -j $(JOBS) \

install: $(MUSL_VERSION_F) $(NIM_VERSION_F) ## Install musl and nim

$(NIM_VERSION_F): $(NIM_BUILT)
	cd src/nim \
	  && ./install.sh $(INSTPREFIX) \
	  && install -m755 ./bin/* $(INSTDIR)/bin \
	  && sed -i~ '/^cc =/a @if musl:\n gcc.exe = "musl-gcc"\n gcc.linkerexe = "musl-gcc"\n@end' $(INSTDIR)/config/nim.cfg \
	  && echo "$(NIM_UPSTREAM)" > $@

$(MUSL_VERSION_F): src/musl
	cd src/musl \
	  && make install \
	  && echo $(MUSL_UPSTREAM) > $@

$(NIM_UNPACKED): src/$(NIM_ARCHIVE)
	mkdir -p src/nim
	tar xJf src/$(NIM_ARCHIVE) --strip-components=1 -C src/nim
	touch $(NIM_UNPACKED)

src/$(NIM_ARCHIVE):
	curl -L $(NIM_URL) -o $@

$(MUSL_UNPACKED): src
	test -d src/musl && rm -rf src/musl || true
	git clone --depth=1 $(MUSL_REPO) src/musl
	touch $(MUSL_UNPACKED)

src:
	mkdir -m755 -p src

# vim:ai:noet:ts=8:
