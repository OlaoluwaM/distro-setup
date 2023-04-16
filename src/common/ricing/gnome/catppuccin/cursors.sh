#!/usr/bin/env bash

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

if [[ $useGit == false ]]; then
  gh repo clone catppuccin/cursors "$HOME/catppuccin-cursors"
else
  git clone https://github.com/catppuccin/cursors.git "$HOME/catppuccin-cursors"
fi

CURSOR_DEST="$HOME/.icons"

EXTRACTION_TARGETS=("Catppuccin-Mocha-Dark-Cursors" "Catppuccin-Mocha-Lavender-Cursors")

for unzipTarget in "${EXTRACTION_TARGETS[@]}"; do
  unzip "$HOME/catppuccin-cursors/${unzipTarget}.zip" -d "$CURSOR_DEST"
done
