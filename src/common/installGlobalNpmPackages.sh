#!/usr/bin/env bash

# Install global NPM packages
# Requirements: Node and NPM, Dotfiles directory
# Depends on: NVM installation and setup script, cloning repos

echo "Installing global NPM packages..."

if ! isProgramInstalled npm; then
  echo "The NPM CLI is required to install global packages from its registry"
  echo "Please install it then re-run this script. Exiting..."
  exit 1
fi

PACKAGES="$DOTS_DIR/npm/global-npm-pkgs.txt"

if ! doesFileExist "$PACKAGES"; then
  echo "Cannot find the list of NPM packages to install. The path to the file containing these packages ($PACKAGES) might not exist."
  echo "Please create this file then re-run this script. Exiting..."
  exit 1
fi

function isPackageInstalled() {
  PACKAGE="$1"
  npm list -g --depth=0 | grep "$PACKAGE" &>/dev/null
}

while read -r package; do
  packageName=${package#*'node_modules/'}

  echo "Installing $packageName..."

  if isPackageInstalled "$packageName"; then
    echo "Seems like $packageName has already been installed. Moving to the next one..."
    continue
  fi

  npm i -g "$packageName"
  echo "$packageName has been installed"

done \
  <"$PACKAGES"

echo "Installations complete"
