#!/usr/bin/env bash

# Install Oh-My-ZSH
# Check for either the curl or wget commands
if [ "$(
  command -v curl &>/dev/null
  echo $?
)" -gt 0 ] && [ "$(
  command -v wget &>/dev/null
  echo $?
)" -gt 0 ]; then
  echo "You need to install either curl or wget in order to install oh-my-zsh"
  sudo dnf install wget curl
fi

# Install oh-my-zsh if it isn't installed already
if ! [[ -d ~/.oh-my-zsh ]]; then
  # If it is not installed
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
else
  echo "Looks like oh-my-zsh is already installed"
fi
