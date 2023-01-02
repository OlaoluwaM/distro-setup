#!/usr/bin/env bash

# Install docker

echo "Installing docker..."
if ! (rpm -qa | grep -E "docker|moby") &>/dev/null; then
  sudo dnf install moby-engine docker-compose -y
  sudo systemctl enable docker
  echo "Done!"
else
  echo "Seems like docker has already been installed"
fi
echo -e "\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

echo "Creating docker group..."
# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
if ! (getent group docker | grep "$USER") &>/dev/null; then
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  echo "Done! You may need to logout and then back in to see the changes"
else
  echo "Seems like you have already been added to the docker group. Moving on..."
fi
