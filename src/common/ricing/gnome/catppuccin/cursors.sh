#!/usr/bin/env bash

cursors_dir="$HOME/.local/share/icons"

if doesDirExist "$cursors_dir/Catppuccin-Mocha-Dark-Cursors" && doesDirExist "$cursors_dir/Catppuccin-Mocha-Lavender-Cursors"; then
  echo "Looks like cursor themes have already been installed. Skipping...."
  return
fi

if ! isProgramInstalled gh || ! isProgramInstalled git; then
  echo "This script requires that either the Github CLI or git be installed on your system"
  echo "Please install either then try again"
  return
fi

if isProgramInstalled gh; then
  useGit=false
else
  echo "Seems like you do not have the github cli installed. Will fallback to using regular git instead"
  useGit=true
fi

# https://github.com/catppuccin/cursors
if [[ $useGit == false ]]; then
  gh repo clone catppuccin/cursors "$HOME/catppuccin-cursors"
else
  git clone https://github.com/catppuccin/cursors.git "$HOME/catppuccin-cursors"
fi

EXTRACTION_TARGETS=("Catppuccin-Mocha-Dark-Cursors" "Catppuccin-Mocha-Lavender-Cursors")

echo "Unzipping cursor files..."
for unzipTarget in "${EXTRACTION_TARGETS[@]}"; do
  unzip "$HOME/catppuccin-cursors/cursors/${unzipTarget}.zip" -d "$cursors_dir"
done
echo -e "Done!\n"

echo "Setting Cursor theme..."
gsettings set org.gnome.desktop.interface cursor-theme "Catppuccin-Mocha-Dark-Cursors"
echo -e "Done!\n"

echo "Removing artifacts..."
rm -rf "$HOME/catppuccin-cursors"
echo "Done!"
