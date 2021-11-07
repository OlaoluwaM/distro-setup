#!/usr/bin/env bash

# Install oh-my-zsh if it isn't installed already
if [[ ! -d ~/.oh-my-zsh ]]; then
  # If it is not installed
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
  echo "OMZ successfully installed"
  echo "You may need to log out and back in again"
  exit 0
else
  echo "Looks like oh-my-zsh is already installed"
fi
printf "\n"
