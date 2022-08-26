#!/usr/bin/env bash

# Requires rust and cargo to be installed
# Invoke after installMisc script
CURR_DIR="$(dirname "$0")"

if command -v cargo &>/dev/null; then
  echo "Installing some Rust crates..."

  while IFS= read -r crate; do
    CRATES+=("$crate")
  done <"$CURR_DIR/rust-crates.txt"

  echo "Installing ${CRATES[*]}"
  cargo install "${CRATES[@]}"

  echo -e "${CRATES[*]} installed successfully!\n"
else
  echo -e "Rust needs to be installed first. Skipping...."
fi
