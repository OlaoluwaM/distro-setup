#!/usr/bin/env bash

sudo dnf update -y
printf "\n"

if command -v snap &>/dev/null; then

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

    echo "Setup complete"
  fi

  echo "Installing a few snaps...."

  snapsToInstall=("audible-for-linux" "scrcpy")

  echo "Installing some snaps"

  for snapToInstall in "${snapsToInstall[@]}"; do
    if (snap list | grep "$snapToInstall") &>/dev/null; then
      echo "Seems like $snapToInstall has already been installed. Skipping...."
    else
      echo "Installing $snapToInstall..."
      sudo snap install "$snapToInstall" -y
      [[ $? -eq 0 ]] && echo "Successfully installed $snapToInstall"
    fi
    printf "\n"
  done

  echo "Snap setup complete"
else
  echo "Looks like snap hasn't been installed on your system :/"
  exit 1
fi
printf "\n"
