#!/usr/bin/env bash

# Install and setup Oh My Zsh
# Requirements: curl

echo "Installing Oh-My-Zsh..."

if ! isProgramInstalled curl; then
  echo "We need curl to install Oh My Zsh"
  echo "Please install curl then re-run this script. Exiting..."
  exit 1
fi

OMZ_DIR="$HOME/.oh-my-zsh"

if ! isDirEmpty "$OMZ_DIR"; then
  echo "Looks like Oh My Zsh has already been installed. Skipping..."
  return
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "OMZ successfully installed!"

echo "Exiting so changes can take effect. Re-run this script to carry on"
exit 0
