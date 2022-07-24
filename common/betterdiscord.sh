#!/usr/bin/env bash

if ! command -v betterdiscordctl &>/dev/null; then
  echo "Installing betterdiscordctl"
  sudo dnf copr enable observeroftime/betterdiscordctl
  sudo dnf install betterdiscordctl -y
  echo "betterdiscordctl installed"
fi
