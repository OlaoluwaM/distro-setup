#!/usr/bin/env bash

# Install the speedtest CLI

echo "Installing speedtest cli..."

if isProgramInstalled speedtest; then
  echo "The speedtest CLI has already been installed. Skipping..."
  return
fi

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
sudo dnf install speedtest -y
echo "Installation complete"
