#!/usr/bin/env bash

# Requires GitHub Cli and GitHub CLI extensions
# Requires spotify to be installed from Flathub
# For other themes check https://github.com/spicetify/spicetify-themes
SPICE_DIR="$HOME/.config/spicetify"

if ! command -v spicetify &>/dev/null; then

  echo "Installing spicetify..."
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
  echo -e "Done!\n"

  mkdir "$SPICE_DIR/CustomApps"

  echo "Spicetify component installation complete"
  echo -e "You will still need to hook some things up manually!\n"

else 
  echo -e "Spicetify components have already been installed\n"
fi
