#!/usr/bin/env bash

# Install global NPM packages
# Requirements: Node and NPM
# Depends on: NVM installation and setup script

if ! isProgramInstalled npm; then
  echo "This script requires NPM to be installed. Exiting..."
  exit 1
fi

function isPackageInstalled() {
  PACKAGE="$1"
  npm list -g --depth=0 | grep "$PACKAGE" &>/dev/null
}

echo "Installing global NPM packages..."
PACKAGES="$DOTFILES/npm/global-npm-pkgs.txt"

while read -r package; do
  packageName=${package#*'node_modules/'}

  if isPackageInstalled "$packageName"; then
    echo "Seems like $packageName has already been installed."
    continue
  fi

  echo "Installing $packageName..."
  npm i -g "$packageName"
  echo "$packageName has been installed"

done \
  <"$PACKAGES"

echo "Installations complete"
