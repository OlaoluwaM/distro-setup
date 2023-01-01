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

echo "Creating backup of previous NVIM configuration...\c"
mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak"
echo "Done!"

echo "Installing AstroNvim..."
git clone https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"
mkdir -p "$HOME/.config/nvim/lua/user"
cp -a "$HOME/.config/nvim/lua/user_example/." "$HOME/.config/nvim/lua/user"
echo "Installation complete!"

echo "Updating AstroNvim dependencies..."
nvim +PackerSync
echo "Update complete!"

echo "AstroNvim has been installed and configured"