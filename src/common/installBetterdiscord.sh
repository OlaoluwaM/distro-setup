#!/usr/bin/env bash

if ! command -v betterdiscordctl &>/dev/null; then
  echo "Installing betterdiscordctl"
  sudo dnf copr enable observeroftime/betterdiscordctl -y
  sudo dnf install betterdiscordctl -y
  echo "betterdiscordctl installed"
  printf "\n"
fi

echo "You will need to login to discord before betterdiscord can act on it. Refer to the manualInstructions.md"
printf "\n"
