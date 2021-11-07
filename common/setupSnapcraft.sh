#!/usr/bin/env bash

# Requires snapd and snap

sudo dnf update -y
printf "\n"

if ! command -v snap &>/dev/null; then
  echo "Looks like snapd hasn't been installed. Installing..."
  sudo dnf install -y snapd
  echo "Done"
  printf "\n"
fi

if ! systemctl status snapd &>/dev/null; then
  echo "Setting up snap...."
  sudo systemctl restart snapd
  sudo ln -s /var/lib/snapd/snap /snap
  sudo snap install core

  if ! systemctl status snapd &>/dev/null; then
    echo "Hmmm, seems like the snapd is not up, fixing...."
    sudo systemctl start snap
    echo "Done"
  fi

  echo "Setup complete. You will need to log out and back then re-run the script"
  exit 0
fi

echo "Installing a few snaps...."

snapsToInstall=("audible-for-linux" "scrcpy")

echo "Installing some snaps"

for snapToInstall in "${snapsToInstall[@]}"; do
  if (snap list | grep "$snapToInstall") &>/dev/null; then
    echo "Seems like $snapToInstall has already been installed. Skipping...."
  else
    echo "Installing $snapToInstall..."
    sudo snap install "$snapToInstall"
    [[ $? -eq 0 ]] && echo "Successfully installed $snapToInstall"
  fi
  printf "\n"
done

echo "Snap setup complete"
printf "\n"
