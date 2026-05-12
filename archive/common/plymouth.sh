#!/usr/bin/env bash

if doesDirExist "/usr/share/plymouth/themes/catppuccin-mocha/"; then
  echo "Plymouth theme has already been installed and set. Skipping..."
  return
fi

if isProgramInstalled gh; then
  useGit=false
else
  echo "Seems like you do not have the github cli installed. Will fallback to using regular git instead"
  useGit=true
fi

if ! isProgramInstalled gh || ! isProgramInstalled git; then
  echo "This script requires that either the Github CLI or git be installed on your system"
  echo "Please install either then try again"
  return
fi

echo "Customizing Plymouth theme"
echo "Installing Catppuccin Plymouth theme"

if [[ $useGit == false ]]; then
  gh repo clone catppuccin/plymouth catppuccin-plymouth
else
  git clone git@github.com:catppuccin/plymouth.git catppuccin-plymouth
fi

sudo cp -r catppuccin-plymouth/themes/catppuccin-mocha /usr/share/plymouth/themes
echo -e "Done!\n"

echo "Setting theme as default..."
sudo plymouth-set-default-theme -R catppuccin-mocha
echo -e "Done!\n"

echo "Removing artifacts..."
rm -rf "$HOME/catppuccin-plymouth"
echo "Done"
