#!/usr/bin/env bash

# Fix zsh-syntax-highlighting and zsh-autosuggestions
# Requirements: git, ssh connection to GitHub

echo "Attempting to fix the zsh-syntax-highlighting and zsh-autosuggestions plugins"

if ! isProgramInstalled git || [[ $(
  ssh -T git@github.com &>/dev/null
  echo $?
) -ne 1 ]]; then
  echo "Git needs to be installed with a valid SSH connection to apply these OMZ plugin fixes"
  echo "Please install git and setup a valid ssh (or http) connection with it then re-run this script. Moving on..."
  return
fi

echo "Fixing zsh-syntax-highlighting..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  echo "Done!"
else
  echo "The zsh-syntax-highlighting plugin has already been fixed"
fi
echo -e "\n"

echo "Fixing zsh-autosuggestions..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  echo "Done!"
else
  echo "The zsh-autosuggestions plugin has already been fixed"
fi
