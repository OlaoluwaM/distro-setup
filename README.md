# Fedora Workstation Setup

Personal Fedora bootstrap scripts for setting up my workstation from a fresh install.

This repo is intentionally Fedora-only. The active setup code lives under `src`:

- `src/setup.sh` is the single entry point.
- `src/lib/core.sh` contains shared setup helpers.
- `src/steps/` contains active setup steps.
- `src/assets/` contains install lists, templates, and manual instructions.
- `archive/` contains old scripts that are not part of the active setup flow.

## Usage

1. Copy `src/assets/env_template.txt` to `src/.env`.
2. Fill in the required environment variables.
3. Run `src/setup.sh`.
4. If a step pauses for shell reload, logout, reboot, or manual setup, do that and rerun `src/setup.sh`.

The setup is designed to be rerunnable. Steps should either perform their work, report that the work is already done, skip because a dependency is missing, or intentionally pause with instructions to rerun.

## Maintenance

- Fedora packages live in `src/assets/packages.txt`.
- Rust crates live in `src/assets/rust-crates.txt`.
- Flatpak app IDs live in `src/assets/flatpaks.txt`.
- Repositories to clone live in `src/assets/repos.tsv`.
- Filesystem directories live in `src/assets/directories.txt`.

Useful maintenance commands:

- `make fmt`
- `make lint`
- `make check`
