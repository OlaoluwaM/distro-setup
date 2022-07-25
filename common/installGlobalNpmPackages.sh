#!/usr/bin/env bash

# Requires npm and node

if command -v node &>/dev/null && command -v npm &>/dev/null; then
  echo "Installing global npm packages"

  PACKAGES="$DOTFILES/npm/global-npm-pkgs.txt"

  while read -r package; do
    packageName=${package#*'node_modules/'}

    if (npm list -g --depth=0 | grep "$packageName") &>/dev/null; then
      echo "Seems like $packageName is already installed. Skipping...."
    else
      echo "Installing $packageName"
      npm i -g "$packageName"
      echo "$packageName installed"
    fi

    printf "\n"
  done <"$PACKAGES"

  echo "Installations complete"
fi
