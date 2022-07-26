#!/usr/bin/env bash

if ! command -v betterdiscordctl &>/dev/null; then
  echo "Installing betterdiscordctl"
  sudo dnf copr enable observeroftime/betterdiscordctl
  sudo dnf install betterdiscordctl -y
  printf "\n"
  
  echo "Augmenting Discord with BetterDiscord"
  betterdiscordctl --d-install flatpak install
  echo "betterdiscordctl installed"
  printf "\n"
fi