#!/usr/bin/env bash

# commonScriptsDir="$(dirname "$0")"

sudo dnf update -y
printf "\n"

if command -v snap &>/dev/null; then
  echo "Setting up snap"
  snapsToInstall=("audible-for-linux" "scrcpy")

  echo "Installing some snaps"

  for snapToInstall in "${snapsToInstall[@]}"; do
    if (snap list | grep "$snapToInstall") &>/dev/null; then
      echo "Seems like $snapToInstall has already been installed. Skipping...."
    else
      echo "Installing $snapToInstall..."
      sudo snap install "$snapToInstall"
      [[ $? -eq 0 ]] && echo "Successfully installed $snapToInstall"
    fi
    printf "\n"
  done

  echo "Snap setup complete"
else
  echo "Looks like snap hasn't been installed on your system :/"
  exit 1
fi
printf "\n"
