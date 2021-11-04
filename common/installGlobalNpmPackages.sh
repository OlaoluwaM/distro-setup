#!/usr/bin/env bash

commonScriptsDir="$(dirname "$0")"
source "$commonScriptsDir/isInstalled.sh"

if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  echo "Installing some global npm packages"
  packages=("spaceship" "typescript" "create-react-app" "serve" "fkill-cli" "@bitwarden/cli" "term-of-the-day" "@types/node" "netlify-cli" "nativefier")

  for package in "${packages[@]}"; do
    echo "Installing $package"
    npm i -g "$package"
    echo "$package installed"
  done

  echo "Installations complete"
fi
