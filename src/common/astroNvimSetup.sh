#!/usr/bin/env bash

# Install and setup AstroNvim
# Requirements: git (with a valid ssh connection)
# Depends on: Packages install, Misc install using other language package managers, done before dotfiles are symlinked

# Follow steps outlined here: https://github.com/AstroNvim/AstroNvim
# Create ~/.config/nvim/lua/user
# Copy ~/.config/nvim/lua/user_example to ~/.config/nvim/lua/user
# Copy dotfiles neovim config to ~/.config/nvim/lua/user directory

echo "Installing & setting up AstroNvim...."

if doesDirExist "$HOME/.config/nvim/lua/user"; then
  echo "AstroNvim has already been installed and setup. Moving on..."
  return
fi

echo "Installing AstroNvim..."
git clone https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/lua/user"
cp -a "$HOME/.config/nvim/lua/user_example/." "$HOME/.config/nvim/lua/user"
echo -e "Installation complete!\n"

echo "Updating AstroNvim dependencies..."
nvim +PackerSync
echo -e "Update complete!\n"

echo "AstroNvim has been installed and configured"
