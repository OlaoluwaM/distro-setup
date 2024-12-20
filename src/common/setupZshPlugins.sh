#!/usr/bin/env bash

echo "Attempting to fix the zsh-syntax-highlighting and zsh-autosuggestions plugins"

if ! isProgramInstalled git || [[ $(
  ssh -T git@github.com &>/dev/null
  echo $?
) -ne 1 ]]; then
  echo "Git needs to be installed with a valid SSH connection to apply these OMZ plugin fixes"
  echo "Please install git and setup a valid ssh (or http) connection with it then re-run this script. Moving on..."
  return
fi

echo "Fixing zsh-autosuggestions..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  echo "Done!"
else
  echo "The zsh-autosuggestions plugin has already been fixed"
fi
echo -e "\n"

# Switching to fsh (fast-syntax-highlighting)
echo "Installing fsh (fast-syntax-highlighting) plugin..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"; then
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
  echo "Installation Complete!"
else
  echo "The fast-syntax-highlighting plugin has already been installed"
fi
echo -e "\n"

# you-should-use (https://github.com/MichaelAquilina/zsh-you-should-use)
echo "Installing you-should-use plugin..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use"; then
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use"
  echo "Installation Complete!"
else
  echo "The you-should-use plugin has already been installed"
fi
