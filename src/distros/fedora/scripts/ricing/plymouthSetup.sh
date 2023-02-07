#!/usr/bin/env bash

# Needs some guard checks, but this is pretty much it

echo "Customizing Plymouth theme"
echo "Installing Catppuccin Plymouth theme"
gh repo clone catppuccin/plymouth catppuccin-plymouth
sudo cp -r catppuccin-plymouth/themes/catppuccin-mocha /usr/share/plymouth/themes

echo "Setting theme as default"
sudo plymouth-set-default-theme -R catppuccin-mocha
