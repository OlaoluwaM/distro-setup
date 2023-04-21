#!/usr/bin/env bash

# Setup ProtonVPN
# Requirements:
# Depends on: Package installation step

# Checkout the following for installation steps
# https://protonvpn.com/support/linux-vpn-tool/#fedora (for the cli)
# https://protonvpn.com/support/official-linux-vpn-fedora/ (for the gui)

echo "Installing protonvpn CLI and GUI..."

if isProgramInstalled protonvpn-cli && isProgramInstalled protonvpn; then
  echo "Looks like you already have both the protonvpn CLI and GUI installed. Moving on..."
  return
fi

sudo dnf install "https://repo.protonvpn.com/fedora-36-stable/release-packages/protonvpn-stable-release-1.0.1-1.noarch.rpm" -y
sudo dnf update -y

sudo dnf install protonvpn-cli protonvpn -y
echo "Installation complete!"
