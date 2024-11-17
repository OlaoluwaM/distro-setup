#!/usr/bin/env bash

# https://github.com/catppuccin/cursors

echo "Installing Catppuccin Cursors..."

cursors_dir="$HOME/.icons"
cursor_version="1.0.1"

if doesDirExist "$cursors_dir/catppuccin-mocha-dark-cursors" && doesDirExist "$cursors_dir/catppuccin-mocha-lavender-cursors"; then
  echo "Looks like cursor themes have already been installed. Skipping...."
  return
fi

EXTRACTION_TARGETS=("catppuccin-mocha-dark-cursors" "catppuccin-mocha-lavender-cursors")

for unzipTarget in "${EXTRACTION_TARGETS[@]}"; do
  echo "Downloading and unzipping ${unzipTarget} cursor files..."
  curl -LOsS "https://github.com/catppuccin/cursors/releases/download/v${cursor_version}/${unzipTarget}.zip"
  unzip "${unzipTarget}.zip" -d "$cursors_dir"
  rm "${unzipTarget}.zip"
  echo -e "Done!\n"
done

echo -e "Download and unzip complete!\n"

echo "Setting Cursor theme..."
gsettings set org.gnome.desktop.interface cursor-theme "catppuccin-mocha-dark-cursors"
echo "Done!"
