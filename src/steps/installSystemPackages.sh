#!/usr/bin/env bash

# kernel-devel is for OpenRazer. There is an issue on Fedora that warrants its installation.
# g++ is needed for nvim-treesitter and compiling the difftastic Rust crate.
# texlive-scheme-full is for full LaTeX support in Fedora.
# z3 is the SMT solver for Liquid Haskell.
echo "Installing system packages..."

linuxPackages=()
while IFS= read -r package; do
	[[ -z "$package" || "$package" == \#* ]] && continue
	linuxPackages+=("$package")
done <"$SETUP_ASSETS_DIR/packages.txt"

sudo dnf install --skip-unavailable -y "${linuxPackages[@]}"
echo "System packages installed"
