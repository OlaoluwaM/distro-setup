#!/usr/bin/env bash

# Install oh-my-zsh if it isn't installed already
if ! [[ -d ~/.oh-my-zsh ]]; then
  # If it is not installed
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
else
  echo "Looks like oh-my-zsh is already installed"
fi
