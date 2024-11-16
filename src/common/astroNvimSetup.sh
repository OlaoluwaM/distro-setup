#!/usr/bin/env bash

# Setup AstroNvim

echo "Installing & setting up AstroNvim...."

if doesDirExist "$XDG_CONFIG_HOME/nvim"; then
  echo "AstroNvim has already been installed and setup. Moving on..."
  return
fi

if git ls-remote https://github.com/OlaoluwaM/nvim-setup.git &>/dev/null; then
  echo "Installing AstroNvim from our git repo (https://github.com/OlaoluwaM/nvim-setup)..."
  git clone https://github.com/OlaoluwaM/nvim-setup "$XDG_CONFIG_HOME/nvim"
  echo -e "Updating AstroNvim dependencies...\n"
  nvim +AstroUpdate
  echo "Update complete!"
  return
fi

echo "Installing AstroNvim..."
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone --depth 1 https://github.com/AstroNvim/template "$XDG_CONFIG_HOME/nvim"
rm -rf ~/.config/nvim/.git

echo "Updating AstroNvim dependencies..."
nvim +AstroUpdate
echo "Update complete!"

echo "AstroNvim has been installed and configured"
