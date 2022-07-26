#!/usr/bin/env bash

# Requires GitHub Cli and GitHub CLI extensions
if ! command -v spicetify &>/dev/null; then
  echo "Installing spicetify..."
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
  echo -e "Done!\n"

  echo "Installing spicetify theme: Comfy"
  curl -fsSL https://raw.githubusercontent.com/NYRI4/Comfy-spicetify/main/install.sh | sh
  echo -e "Done!\n"

  SPICE_DIR="$HOME/.config/spicetify"

  echo "Installing spicetify extensions"
  gh download spicetify/spicetify-cli Extensions/fullAppDisplay.js --output "$SPICE_DIR/Extensions"
  gh download spicetify/spicetify-cli Extensions/shuffle+.js --output "$SPICE_DIR/Extensions"
  gh download spicetify/spicetify-cli Extensions/popupLyrics.js --output "$SPICE_DIR/Extensions"
  echo -e "Done!\n"

  echo "Installing spicetify custom apps"
  gh download spicetify/spicetify-cli CustomApps/lyrics-plus/ --output "$SPICE_DIR/CustomApps/"
  echo -e "Done!\n"

  echo -e "Spicetify component installation complete\n"

else
  echo -e "Spicetify components have already been installed\n"
fi
