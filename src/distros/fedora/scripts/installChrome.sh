#!/usr/bin/env bash

# Install Google Chrome

# https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/

if ! isProgramInstalled google-chrome; then
  echo "Installing Google Chrome..."
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager setopt --set-enabled google-chrome -y
  sudo dnf install -y google-chrome-stable
  echo "Done"
else
  echo "Google Chrome has already been installed"
fi
