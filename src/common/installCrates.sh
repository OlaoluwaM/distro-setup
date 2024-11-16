#!/usr/bin/env bash

# This script installs a list of Rust crates from crates.io using cargo-binstall
#
# Requires: cargo, cargo-binstall

# shellcheck disable=SC2154

echo "Installing Rust crates..."

if ! isProgramInstalled cargo || ! isProgramInstalled cargo-binstall; then
	echo "Before any rust programs can be installed, the cargo package manager or cargo-binstall must be available"
	echo "Please install cargo or cargo-binstall then re-run this script. Skipping..."
	return
fi

crates_that_require_special_install=("yazi-fm" "yazi-cli" "sad" "rip2")

while IFS= read -r crate_name; do
	if [[ "${crates_that_require_special_install[*]}" =~ ${crate_name} ]]; then
		echo "Skipping installing $crate_name because it requires a bespoke installation process..."
		continue
	fi

	echo "Attempting to install $crate_name using cargo-binstall..."
	if cargo binstall -y "$crate_name"; then
		# If binary cannot be installed then the command will attempt to install from source
		echo "Successfully installed $crate_name using cargo-binstall."
	else
		echo "Failed to install $crate_name using cargo-binstall."
	fi
done <"$commonScriptsDir/assets/rust-crates.txt"

echo -e "\nInstalling crates with special install steps..."

# sad (https://github.com/ms-jpq/sad): cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
if ! isProgramInstalled sad; then
	echo "Installing sad..."
	cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
else
	echo "sad is already installed"
fi
echo -e "\n"

# yazi (https://yazi-rs.github.io/docs/installation): cargo install --locked yazi-fm
if ! isProgramInstalled yazi-fm || ! isProgramInstalled yazi-cli; then
	echo "Installing yazi-fm and yazi-cli..."
	cargo binstall -y --locked yazi-fm yazi-cli
else
	echo "yazi is already installed"
fi
echo -e "\n"

# rip2 (https://github.com/variadico/rip2): cargo install --locked rip2
if ! isProgramInstalled rip2; then
	echo "Installing rip2..."
	cargo binstall -y --locked rip2
else
	echo "rip2 is already installed"
fi
