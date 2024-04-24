#!/usr/bin/env bash

# Setup ProtonVPN
# Requirements:
# Depends on: Package installation step

# Checkout the following for installation steps
# https://protonvpn.com/support/linux-vpn-tool/#fedora (for the cli)
# https://protonvpn.com/support/official-linux-vpn-fedora/ (for the gui)

echo "Installing protonvpn..."

if isProgramInstalled protonvpn-cli && isProgramInstalled protonvpn; then
  echo "Looks like you already have both the protonvpn CLI and GUI installed. Moving on..."
  return
fi

sudo dnf install "https://repo.protonvpn.com/fedora-39-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm" -y
sudo dnf update -y

sudo dnf install --refresh proton-vpn-gnome-desktop -y
echo "Installation complete!"
