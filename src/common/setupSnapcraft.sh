#!/usr/bin/env bash

# Setup Snapcraft and install some snaps

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo "Setting up snap service..."

if ! isProgramInstalled snap; then
  echo "Looks like snapd hasn't been installed. Installing..."
  sudo dnf install -y snapd
  echo "Done"
else
  echo "Looks like snapd has already been installed"
fi

if ! systemctl status snapd &>/dev/null; then
  sudo systemctl restart snapd
  sudo ln -s /var/lib/snapd/snap /snap
  sudo snap install core

  if ! systemctl status snapd &>/dev/null; then
    echo "Hmmm, seems like the snapd service is still not running, attempting a fix..."
    sudo systemctl start snap
    echo "Done!"
  fi

  # shellcheck disable=SC2181
  if [[ $? -eq 0 ]]; then
    echo "Setup complete! You will need to log out and back, then re-run this script"
    exit 0
  else
    echo "Oops, looks like something went wrong with setting up the snapd service? Re-run the script and try again?"
    exit 1
  fi
else
  echo "Looks like the snap service is already up and running"
fi
echo -e "\n"

echo "Installing a few snaps...."
snapsToInstall=("scrcpy" "ticktick")

for snapToInstall in "${snapsToInstall[@]}"; do
  echo "Installing $snapToInstall..."

  if (snap list | grep "$snapToInstall") &>/dev/null; then
    echo "Seems like $snapToInstall has already been installed. Moving to the next one...."
  else
    sudo snap install "$snapToInstall"
    # shellcheck disable=SC2181
    if [[ $? -eq 0 ]]; then
      echo "Successfully installed $snapToInstall"
    else
      echo "Failed to install $snapToInstall"
    fi
  fi
done

echo "Snaps successfully installed"
