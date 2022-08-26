#!/usr/bin/env bash

# Follow steps outlined here: https://github.com/AstroNvim/AstroNvim
# Create ~/.config/nvim/lua/user
# Copy ~/.config/nvim/lua/user_example to ~/.config/nvim/lua/user
# Copy dotfiles neovim config to ~/.config/nvim/lua/user directory

# Should be executed after linux package install and misc package install
# Should come before dotfiles symlinking

if [[ ! -d "$HOME/.config/nvim/lua/user" ]]; then
  echo "Setting up AstroNvim...."
  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  mkdir -p ~/.config/nvim/lua/user
  cp -r ~/.config/nvim/lua/user_example/* ~/.config/nvim/lua/user
  nvim +PackerSync
  echo -e "Set up complete!\n"
else
  echo -e "AstroNvim may have already been installed. Skipping...\n"
fi
