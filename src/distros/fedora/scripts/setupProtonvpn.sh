#!/usr/bin/env bash

# Setup ProtonVPN
# Requirements:
# Depends on: Package installation step

# Checkout the following for installation steps
# https://protonvpn.com/support/linux-vpn-tool/#fedora
# https://protonvpn.com/support/official-linux-vpn-fedora/

if isProgramInstalled protonvpn-cli; then
  echo -e "Looks like you already have protonvpn installed."
  return
fi

echo "Setting up protonvpn-cli & protonvpn GUI..."
sudo rpm -i "https://protonvpn.com/download/protonvpn-stable-release-1.0.1-1.noarch.rpm" -y
sudo dnf update -y

sudo dnf install protonvpn-cli protonvpn -y
echo "Setup complete!"
