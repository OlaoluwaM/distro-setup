#!/usr/bin/env bash

# kernel-devel is for OpenRazer. There is an issue on Fedora that warrants its installation.
# gcc-c++ is needed for nvim-treesitter and compiling the difftastic Rust crate.
# texlive-scheme-full is for full LaTeX support in Fedora.
# z3 is the SMT solver for Liquid Haskell.
echo "Installing system packages..."

linuxPackages=()
availablePackages=()
unavailablePackages=()
while IFS= read -r package; do
	[[ -z "$package" || "$package" == \#* ]] && continue
	linuxPackages+=("$package")
done <"$SETUP_ASSETS_DIR/packages.txt"

for package in "${linuxPackages[@]}"; do
	if dnf list --quiet "$package" &>/dev/null; then
		availablePackages+=("$package")
	else
		unavailablePackages+=("$package")
	fi
done

if [[ ${#availablePackages[@]} -gt 0 ]]; then
	runOrFail "Could not install all available system packages." sudo dnf install --skip-unavailable -y "${availablePackages[@]}"
	success "Available system packages installed"
else
	alreadyDone "No available system packages needed installation"
fi

if [[ ${#unavailablePackages[@]} -gt 0 ]]; then
	warn "Skipped unavailable packages:"
	printf ' - %s\n' "${unavailablePackages[@]}"
fi

success "System package step complete"
