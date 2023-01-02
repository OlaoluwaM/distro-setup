#!/usr/bin/env bash

# Install Rust crates
# Requirements: rust, cargo
# Depends on: installMisc.sh
# shellcheck disable=SC2154

echo "Installing Rust crates..."

if ! isProgramInstalled cargo; then
  echo "Before any cargo packages can be installed, the cargo package manager must be available"
  echo "Please install cargo or exit the session then come back. After, re-run this script. Skipping..."
  return
fi

CRATES=("starship" "fd-find" "ripgrep" "sd" "navi" "zoxide" "exa")

while IFS= read -r crate; do
  CRATES+=("$crate")
done <"$commonScriptsDir/assets/rust-crates.txt"

# To remove duplicates (https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash)
CRATES=("$(echo "${CRATES[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')")

echo "Installing ${CRATES[*]}...."
cargo install "${CRATES[@]}"
