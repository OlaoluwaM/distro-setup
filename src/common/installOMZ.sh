#!/usr/bin/env bash

# Install and setup Oh My Zsh
# Requirements: curl

if ! isProgramInstalled curl; then
  echo "You need to install curl to install oh-my-zsh"
  exit 1
fi

OMZ_DIR="$HOME/.oh-my-zsh"

if ! isDirEmpty "$OMZ_DIR"; then
  echo "Looks like oh-my-zsh is already installed"
  return
fi

echo "Installing Oh-My-Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "OMZ successfully installed! Exiting so changes can take effect. Re-run this script to carry on"
exit 0
