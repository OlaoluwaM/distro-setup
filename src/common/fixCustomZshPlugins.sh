#!/usr/bin/env bash

# Fix zsh-syntax-highlighting and zsh-autosuggestions
# Requirements: git, ssh connection to GitHub

ssh -T git@github.com &>/dev/null
GIT_AUTH_STATUS_CHECK_EXIT_CODE="$?"

if ! isProgramInstalled git || [[ $GIT_AUTH_STATUS_CHECK_EXIT_CODE -ne 1 ]]; then
  echo "Git needs to be installed with a valid SSH connection to run this script"
  echo "Please install git or setup a valid ssh (or http) connection before trying again"
  return
fi

if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"; then
  echo "Fixing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  echo "Done!"
fi

if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"; then
  echo "Fixing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  echo "Done!"
fi
