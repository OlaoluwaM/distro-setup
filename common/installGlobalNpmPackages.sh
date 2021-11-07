#!/usr/bin/env bash

# Requires npm and node

if command -v node &>/dev/null && command -v npm &>/dev/null; then
  echo "Installing some global npm packages"
  packages=("spaceship-prompt" "typescript" "create-react-app" "serve" "fkill-cli" "@bitwarden/cli" "term-of-the-day" "@types/node" "netlify-cli" "nativefier")

  for package in "${packages[@]}"; do
    if (npm list -g --depth=0 | grep "$package") &>/dev/null; then
      echo "Seems like $package is already installed. Skipping...."
    else
      echo "Installing $package"
      npm i -g "$package"
      echo "$package installed"
    fi
    printf "\n"
  done

  echo "Installations complete"
fi
