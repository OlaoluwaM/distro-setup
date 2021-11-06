#!/usr/bin/env bash

# commonScriptsDir="$(dirname "$0")"
# source "$commonScriptsDir/isInstalled.sh"

sudo dnf update -y
printf "\n"

# Install anime-downloader
if ! command -v anime &>/dev/null; then
  echo "Installing anime-downloader with pip3...."
  pip3 install anime-downloader
  echo "Installed anime-downloader $(anime --version)"
else
  echo "anime-downloader already intstalled"
fi
printf "\n"

# For tmp mail CLI
if ! command -v tmpmail &>/dev/null; then
  echo "Installing tmpmail cli...."
  wget https://raw.githubusercontent.com/sdushantha/tmpmail/master/tmpmail -P "$HOME"
  sudo chmod -v +x "$HOME/tmpmail"

  echo "Installed tmpmail cli"
else
  echo "tmpmail already installed"
fi
printf "\n"

# For termdown
if ! command -v termdown &>/dev/null; then
  echo "Installing termdown CLI timer..."
  pip install termdown
  echo "Installed termdown CLI timer"
else
  echo "termdown already installed"
fi
printf "\n"
