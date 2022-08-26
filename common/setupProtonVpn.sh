#!/usr/bin/env bash

# Checkout the following for installation steps
# https://protonvpn.com/support/linux-vpn-tool/#fedora
# https://protonvpn.com/support/official-linux-vpn-fedora/

if ! command -v protonvpn-cli &>/dev/null; then
  echo "Setting up protonvpn-cli & protonvpn GUI..."
  sudo dnf upgrade
  sudo rpm -i "https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm" -y
  sudo dnf update -y
  sudo dnf install protonvpn-cli protonvpn -y
  echo -e "Setup complete!\n"
else
  echo -e "Looks like you already have protonvpn installed, skipping...\n"
fi
