#!/usr/bin/env bash

# Requires npm and node

if command -v node &>/dev/null && command -v npm &>/dev/null; then
  echo "Installing global npm packages"

  PACKAGES="$DOTFILES/npm/global-npm-pkgs.txt"

  while read -r package; do
    packageName=${package#*'node_modules/'}

    if (npm list -g --depth=0 | grep "$packageName") &>/dev/null; then
      echo "Seems like $packageName is already installed. Skipping...."
      printf "\n"
    else
      echo "Installing $packageName"
      npm i -g "$packageName"
      echo -e "\n$packageName installed"
      printf "\n\n"
    fi

  done <"$PACKAGES"

  echo "Installations complete"
fi
printf "\n"
