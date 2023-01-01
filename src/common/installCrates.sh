#!/usr/bin/env bash

# Install Rust crates
# Requirements: rust, cargo
# Depends on: installMisc.sh
# shellcheck disable=SC2154

echo "Installing Rust crates..."

if ! isProgramInstalled cargo; then
  echo "Before any cargo packages can be installed, the cargo package manager must be available"
  echo "Please install cargo then re-run this script. Skipping..."
  return
fi

CRATES=("starship")

while IFS= read -r crate; do
  CRATES+=("$crate")
done <"$commonScriptsDir/assets/rust-crates.txt"

echo "Installing ${CRATES[*]}...."
cargo install "${CRATES[@]}"

echo "${CRATES[*]} installed successfully!"
