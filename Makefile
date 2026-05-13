SHELL := /usr/bin/bash

SHELL_FILES := src/setup.sh src/lib/core.sh $(wildcard src/steps/*.sh) $(wildcard src/steps/ricing/gnome/catppuccin/*.sh) $(wildcard src/steps/ricing/gnome/colloid/*.sh)

.PHONY: fmt lint check run

fmt:
	shfmt -w $(SHELL_FILES)

lint:
	shellcheck -x $(SHELL_FILES)

check:
	bash -n $(SHELL_FILES)
	$(MAKE) lint

run:
	./src/setup.sh
