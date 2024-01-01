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

# Switching to fsh (fast-syntax-highlighting)
echo "Installing fsh (fast-syntax-highlighting) plugin..."
if ! doesDirExist "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"; then
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
  echo "Installation Complete!"
else
  echo "The fast-syntax-highlighting plugin has already been installed"
fi
echo -e "\n"

echo "Setting fst catppuccin theme..."
if ! isProgramInstalled fast-theme; then
  echo "Looks like your .zshrc file hasn't been reloaded to pick up this change. Please reload your .zshrc and try again"
  return
else
  fastThemeStatus=$(fast-theme -s)
  if [[ "$fastThemeStatus" != *"catppuccin-mocha"* ]]; then
    fast-theme XDG:catppuccin-mocha
    echo "Theme set!"
  fi
fi
