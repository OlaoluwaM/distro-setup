#!/usr/bin/env bash

# Install and setup AstroNvim
# Requirements: git (with a valid ssh connection)
# Depends on: Packages install, Misc install using other language package managers, done before dotfiles are symlinked

# Follow steps outlined here: https://github.com/AstroNvim/AstroNvim
# Create ~/.config/nvim/lua/user
# Copy dotfiles neovim config to ~/.config/nvim/lua/user directory

echo "Installing & setting up AstroNvim...."

if doesDirExist "$HOME/.config/nvim/lua/user"; then
  echo "AstroNvim has already been installed and setup. Moving on..."
  return
fi

echo "Installing AstroNvim..."
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone --depth 1 https://github.com/AstroNvim/template "$HOME/.config/nvim"
rm -rf ~/.config/nvim/.git

mkdir -p "$HOME/.config/nvim/lua/user"
echo -e "Installation complete!\n"

echo "Updating AstroNvim dependencies..."
nvim +AstroUpdatePackages
echo "Update complete!"

echo "AstroNvim has been installed and configured"
