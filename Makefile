SHELL := /usr/bin/bash

SHELL_FILES := src/setup.sh $(wildcard src/lib/*.sh) $(wildcard src/steps/*.sh) $(wildcard src/steps/ricing/gnome/catppuccin/*.sh) $(wildcard src/steps/ricing/gnome/colloid/*.sh)
TEST_FILES := $(wildcard tests/*.sh)

.PHONY: fmt lint test check run

fmt:
	shfmt -w $(SHELL_FILES) $(TEST_FILES)

lint:
	shellcheck -x $(SHELL_FILES) $(TEST_FILES)

check:
	bash -n $(SHELL_FILES) $(TEST_FILES)
	$(MAKE) lint
	$(MAKE) test

test:
	bash tests/commandPlanTests.sh

run:
	./src/setup.sh
