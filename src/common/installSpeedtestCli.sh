#!/usr/bin/env bash

# Install the speedtest CLI

echo "Installing speedtest cli..."

if ! isProgramInstalled curl; then
  echo "curl is required to install the speedtest CLI"
  echo "Please install it then re-run this script. Skipping..."
  return
fi

if isProgramInstalled speedtest; then
  echo "The speedtest CLI has already been installed. Skipping..."
  return
fi

cli_download_location="$HOME/Downloads/speedtest-temp"

echo "Downloading & extracting executable..."
mkdir -p "$cli_download_location"
curl https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz | tar -xvz -C "$cli_download_location"
echo -e "Done!\n"

echo "Moving executable to path..."
mv -v "$cli_download_location/speedtest" "$HOME/.local/bin"
rm -rf "$cli_download_location"
echo -e "Done!\n"

echo "Testing installation..."
speedtest --version
echo "Installation complete"
