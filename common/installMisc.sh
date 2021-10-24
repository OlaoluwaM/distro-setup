#!/usr/bin/env bash

sudo dnf update -y
source "./isInstalled.sh"

# Install anime-downloader
if [ "$(isNotInstalled "command -v anime")" ]; then
  pip3 install anime-downloader

  echo "Installed anime-downloader $(anime --version)"
fi

# For tmp mail CLI
if [ "$(isNotInstalled "command -v tmpmail")" ]; then
  wget https://raw.githubusercontent.com/sdushantha/tmpmail/master/tmpmail -P "$HOME"
  sudo chmod -v +x "$HOME/tmpmail"

  echo "Installed tmpmail cli"
fi

# For termdown
if [ "$(isNotInstalled "command -v termdown")" ]; then
  pip install termdown

  echo "Installed termdown CLI timer"
fi
