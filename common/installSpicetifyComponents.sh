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
  mkdir "$SPICE_DIR/Themes"
  mkdir "$SPICE_DIR/Extensions"

  echo "Spicetify installation complete. On next run, this script will install some themes and the marketplace."
  echo -e "Make sure to include any custom color schemes to the relevant theme files afterwards\n"

elif
  command -v spicetify &>/dev/null
then

  # Install steps can be found here: https://github.com/spicetify/spicetify-themes
  if [[ ! -d "$SPICE_DIR/Themes/Sleek" ]]; then
    echo "Installing spicetify themes..."
    git clone https://github.com/spicetify/spicetify-themes.git
    cp -r spicetify-themes/* "$SPICE_DIR/Themes"
    echo -e "Themes successfully installed!\n"
  else
    echo -e "Spicetify themes have already been installed. Skipping...\n"
  fi

  # Install steps can be found here: https://spicetify.app/docs/getting-started#basic-usage
  if [[ ! -d "$SPICE_DIR/CustomApps/marketplace" ]]; then
    echo "Installing spicetify marketplace..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    echo -e "Marketplace successfully installed!\n"
  else
    echo -e "Spicetify marketplace has already been installed. Skipping...\n"
  fi

  echo -e "All spicetify components hav been installed\n"
else
  echo -e "Spicetify components have already been installed. Skipping...\n"
fi
