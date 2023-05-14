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

function isNpmPackageInstalled() {
  PACKAGE="$1"
  pnpm -g ls | grep "$PACKAGE" &>/dev/null
}

while read -r package; do
  packageName=${package}

  if isNpmPackageInstalled "$packageName"; then
    echo -e "Seems like $packageName has already been installed. Moving to the next one...\n"
    continue
  fi

  pnpm add -g "$packageName"
  echo -e "$packageName has been installed\n"

done \
  <"$PACKAGES"

echo "Installations complete"
