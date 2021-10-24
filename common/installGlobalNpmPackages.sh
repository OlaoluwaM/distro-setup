#!/usr/bin/env bash

if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  echo "Installing some global npm packages"
  packages=("spaceship" "typescript" "create-react-app" "serve" "fkill-cli" "@bitwarden/cli" "term-of-the-day" "@types/node" "netlify-cli" "ntl")

  for package in "${packages[@]}"; do
    echo "Installing $package"
    npm i -g "$package"
    echo "$package installed"
  done

  echo "Installations complete"
fi
