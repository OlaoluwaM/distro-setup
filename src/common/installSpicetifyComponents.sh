#!/usr/bin/env bash

# Install ans setup Spicetify
# For other themes check https://github.com/spicetify/spicetify-themes

SPICE_DIR="$HOME/.config/spicetify"

echo "Installing spicetify..."
if ! isProgramInstalled spicetify; then
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
  echo -e "Install complete\n"

  echo "Setting up foundation for spicetify components..."
  mkdir "$SPICE_DIR/CustomApps"
  mkdir "$SPICE_DIR/Themes"
  mkdir "$SPICE_DIR/Extensions"

  echo "Spicetify installation complete. On next run, this script will install some themes and the marketplace."
  echo "Make sure to include any custom color schemes to the relevant theme files afterwards"
elif isProgramInstalled spicetify; then
  echo "Configuring spicetify installation"

  echo "Installing spicetify themes..."
  # Install steps can be found here: https://github.com/spicetify/spicetify-themes
  if [[ ! -d "$SPICE_DIR/Themes/Sleek" ]]; then
    git clone https://github.com/spicetify/spicetify-themes.git
    cp -a spicetify-themes/. "$SPICE_DIR/Themes"
    echo "Themes successfully installed!"
  else
    echo "Spicetify themes have already been installed. Skipping..."
  fi
  echo -e "\n"

  echo "Installing marketplace for custom apps..."
  # Install steps can be found here: https://spicetify.app/docs/getting-started#basic-usage
  if [[ ! -d "$SPICE_DIR/CustomApps/marketplace" ]]; then
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    echo "Marketplace successfully installed!"
  else
    echo "Spicetify marketplace has already been installed. Skipping..."
  fi
  echo -e "\n"

  echo "All spicetify components have been installed!"
else
  echo "Spicetify components have already been installed. Moving on..."
fi
