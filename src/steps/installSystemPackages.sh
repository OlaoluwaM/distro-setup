#!/usr/bin/env bash

# kernel-devel is for OpenRazer. There is an issue on Fedora that warrants its installation.
# gcc-c++ is needed for nvim-treesitter and compiling the difftastic Rust crate.
# texlive-scheme-full is for full LaTeX support in Fedora.
# z3 is the SMT solver for Liquid Haskell.
echo "Installing system packages..."

packagesToInstall=()
while IFS= read -r package; do
	[[ -z "$package" || "$package" == \#* ]] && continue
	packagesToInstall+=("$package")
done <"$SETUP_ASSETS_DIR/packages.txt"

if [[ ${#packagesToInstall[@]} -gt 0 ]]; then
	runOrFail "Could not install all available system packages." sudo dnf install --skip-unavailable -y "${packagesToInstall[@]}"
	success "System packages installed"
else
	failSetup "No system packages configured. Check $SETUP_ASSETS_DIR/packages.txt."
fi

success "System package step complete"
