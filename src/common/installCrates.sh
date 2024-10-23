#!/usr/bin/env bash

# Install Rust crates
# shellcheck disable=SC2154

# We want to use cargo binstall instead of cargo install (https://github.com/cargo-bins/cargo-binstall/tree/main)

# Crates that can be installed with `cargo binstall`
# - procs
# - ripgrep_all
# - onefetch
# - rnr
# - fd-find
# - hyperfine
# - dua-cli
# - tealdeer
# - jql
# - bottom
# - bat
# - aichat
# - zoxide
# - ripgrep
# - fclones
# - lsd
# - navi
# - rip-improved
# - starship
# - cargo-update
# - yazi-fm
# - yazi-cli

echo "Installing Rust crates..."

if ! isProgramInstalled cargo; then
	echo "Before any cargo packages can be installed, the cargo package manager must be available"
	echo "Please install cargo or exit the session then come back. After, re-run this script. Skipping..."
	return
fi

# Give me an array in bash with the string sad, yazi and broot inside

crates_to_skip=("yazi-fm" "sad")

while IFS= read -r crate; do
	if [[ "${crates_to_skip[*]}" =~ ${crate} ]]; then
		echo "Skipping $crate..."
		continue
	fi

	CRATES+=("$crate")
done <"$commonScriptsDir/assets/rust-crates.txt"

# To remove duplicates (https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash)
# shellcheck disable=SC2207
CRATES=($(for crate in "${CRATES[@]}"; do echo "${crate}"; done | sort -u))

echo "Installing ${CRATES[*]}...."
cargo install "${CRATES[@]}"

# The following will need to be installed separaely: sad, broot, yazi
echo "Installing crates with special install steps..."

# sad (https://github.com/ms-jpq/sad): cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
if ! isProgramInstalled sad; then
	echo "Installing sad..."
	cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
else
	echo "sad is already installed"
fi
echo -e "\n"

# yazi (https://yazi-rs.github.io/docs/installation): cargo install --locked yazi-fm
if ! isProgramInstalled yazi; then
	echo "Installing yazi..."
	cargo install --locked yazi-fm
else
	echo "yazi is already installed"
fi
