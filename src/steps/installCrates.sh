#!/usr/bin/env bash

# This script installs a list of Rust crates from crates.io using cargo-binstall
#
# Requires: cargo, cargo-binstall

# shellcheck disable=SC2154

echo "Installing Rust crates..."

if ! isProgramInstalled cargo || ! isProgramInstalled cargo-binstall; then
	echo "Before any rust programs can be installed, the cargo package manager or cargo-binstall must be available"
	skipStep "Please install cargo and cargo-binstall, then re-run this script."
	return
fi

cratesFile="$SETUP_ASSETS_DIR/rust-crates.txt"

if ! doesFileExist "$cratesFile"; then
	echo "Cannot find Rust crate list at $cratesFile"
	return
fi

crates_that_require_special_install=("yazi-fm" "yazi-cli" "sad" "rip2" "ripgrep_all" "cargo-binstall")

function crateCommandName() {
	case "$1" in
	bottom) echo "btm" ;;
	cargo-update) echo "cargo-install-update" ;;
	fd-find) echo "fd" ;;
	ripgrep) echo "rg" ;;
	tealdeer) echo "tldr" ;;
	tre-command) echo "tre" ;;
	*) echo "$1" ;;
	esac
}

while IFS= read -r crate_name; do
	[[ -z "$crate_name" || "$crate_name" == \#* ]] && continue

	for crate in "${crates_that_require_special_install[@]}"; do
		if [[ "$crate" == "$crate_name" ]]; then
			echo -e "Skipping installing $crate_name because it requires a bespoke installation process...\n"
			continue 2
		fi
	done

	commandName="$(crateCommandName "$crate_name")"
	if isProgramInstalled "$commandName"; then
		alreadyDone "$crate_name is installed"
		echo -e "\n"
		continue
	fi

	echo "Attempting to install $crate_name using cargo-binstall..."
	if cargo binstall -y "$crate_name"; then
		# If binary cannot be installed then the command will attempt to install from source
		success "$crate_name installed using cargo-binstall"
		echo -e "\n"
	else
		failSetup "Failed to install $crate_name using cargo-binstall."
	fi
done <"$cratesFile"

echo -e "\nInstalling crates with special install steps...\n"

# sad (https://github.com/ms-jpq/sad): cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
if ! isProgramInstalled sad; then
	echo "Installing sad..."
	runOrFail "Could not install sad." cargo install --locked --all-features --git https://github.com/ms-jpq/sad --branch senpai
else
	alreadyDone "sad is installed"
fi
echo -e "\n"

# yazi (https://yazi-rs.github.io/docs/installation): cargo install --locked yazi-fm
if ! isProgramInstalled yazi || ! isProgramInstalled ya; then
	echo "Installing yazi-fm and yazi-cli..."
	runOrFail "Could not install yazi-fm and yazi-cli." cargo binstall -y --locked yazi-fm yazi-cli
else
	alreadyDone "yazi is installed"
fi
echo -e "\n"

# rip2 (https://github.com/variadico/rip2): cargo install --locked rip2
if ! isProgramInstalled rip; then
	echo "Installing rip2..."
	runOrFail "Could not install rip2." cargo binstall -y --locked rip2
else
	alreadyDone "rip2 is installed"
fi
echo -e "\n"

# ripgrep_all (https://github.com/phiresky/ripgrep-all): cargo install --locked ripgrep_all
if ! isProgramInstalled rga; then
	echo "Installing ripgrep_all..."
	runOrFail "Could not install ripgrep_all." cargo install --locked ripgrep_all
else
	alreadyDone "ripgrep_all is installed"
fi
