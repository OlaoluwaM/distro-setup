#!/usr/bin/env bash

# Install Rust crates
# shellcheck disable=SC2154

echo "Installing Rust crates..."

if ! isProgramInstalled cargo; then
  echo "Before any cargo packages can be installed, the cargo package manager must be available"
  echo "Please install cargo or exit the session then come back. After, re-run this script. Skipping..."
  return
fi

while IFS= read -r crate; do
  CRATES+=("$crate")
done <"$commonScriptsDir/assets/rust-crates.txt"

# To remove duplicates (https://stackoverflow.com/questions/13648410/how-can-i-get-unique-values-from-an-array-in-bash)
# shellcheck disable=SC2207
CRATES=($(for crate in "${CRATES[@]}"; do echo "${crate}"; done | sort -u))

echo "Installing ${CRATES[*]}...."
cargo install "${CRATES[@]}"
