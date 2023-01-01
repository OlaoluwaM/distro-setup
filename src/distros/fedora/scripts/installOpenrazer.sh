#!/usr/bin/env bash

# Install and setup openrazer and polychromatic
# https://openrazer.github.io/#download

echo "Installing Openrazer..."

if ! (rpm -qa | grep "openrazer-meta") &>/dev/null; then
  sudo dnf config-manager --add-repo "https://download.opensuse.org/repositories/hardware:razer/Fedora_$(rpm -E %fedora)/hardware:razer.repo"
  sudo dnf install openrazer-meta
  echo "Openrazer installation complete!"

  echo "Adding current user ($USER) to the plugdev group..."
  sudo gpasswd -a "$USER" plugdev
  echo "Done!"

  echo "Now you can use your mouse! You'll need to reboot for the changes to take effect. After, pleae re-run this script"
  exit 0
else
  echo "OpenRazer has already been installed and configured. Skipping..."
fi
