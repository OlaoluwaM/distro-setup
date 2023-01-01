#!/usr/bin/env bash

# For customizing discord

echo "Installing betterdiscordctl to setup betterdiscord..."
if ! isProgramInstalled betterdiscordctl; then
  sudo dnf copr enable observeroftime/betterdiscordctl -y
  sudo dnf install betterdiscordctl -y
  echo "betterdiscordctl has been installed!"
else
  echo "betterdiscordctl has already been installed"
fi

echo "You will need to login to discord before betterdiscord can act on it. Refer to the manual instructions"
