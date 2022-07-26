#!/usr/bin/env bash

# https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/

if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  sudo dnf install fedora-workstation-repositories -y
  sudo dnf config-manager --set-enabled google-chrome -y
  sudo dnf install google-chrome-stable -y
  echo "Done"
else
  echo "Google Chrome is already installed"
fi
printf '\n'
