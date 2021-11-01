#!/usr/bin/env bash

commonScriptsDir="$(dirname "$0")"
source "$commonScriptsDir/isInstalled.sh"

sudo dnf update -y

if [ "$(isInstalled "command -v snap")" ]; then
  echo "Setting up snap"
  snapsToInstall=("audible-for-linux" "notion-snap" "scrcpy" "pomatez")

  echo "Installing some snaps"

  for snapToInstall in "${snapsToInstall[@]}"; do
    echo "Installing $snapToInstall..."
    sudo snap install "$snapToInstall"

    [ "$(
      snap list | grep $snapToInstall
      echo $?
    )" -eq 0 ] && echo "Successfully installed $snapToInstall"
  done
  echo "Snap setup complete"
else
  echo "Looks like snap hasn't been installed on your system :/"
fi
