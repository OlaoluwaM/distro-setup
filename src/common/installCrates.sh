#!/usr/bin/env bash

# Install Rust crates
# Requirements: rust, cargo
# Depends on: installMisc.sh
# shellcheck disable=SC2154

if ! isProgramInstalled cargo; then
  echo -e "Rust needs to be installed first. Skipping...."
  return
fi

echo "Installing some Rust crates..."
CRATES=("starship")

while IFS= read -r crate; do
  CRATES+=("$crate")
done <"$commonScriptsDir/assets/rust-crates.txt"

echo "Installing ${CRATES[*]}...."
cargo install "${CRATES[@]}"
echo "${CRATES[*]} installed successfully!"
