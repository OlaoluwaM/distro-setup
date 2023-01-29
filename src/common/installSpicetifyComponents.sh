#!/usr/bin/env bash

# Install ans setup Spicetify
# For other themes check https://github.com/spicetify/spicetify-themes

SPICE_DIR="$HOME/.spicetify"
SPICE_CONFIG_DIR="$HOME/.config/spicetify"

echo "Installing spicetify..."

if doesDirExist "$SPICE_DIR" && doesDirExist "$SPICE_CONFIG_DIR/Themes/Sleek" && doesDirExist "$SPICE_CONFIG_DIR/CustomApps/marketplace"; then
  echo "Spicetify components have already been installed. Moving on..."
  return
fi

if doesDirExist "$SPICE_DIR" && ! isProgramInstalled spicetify; then
  echo "Seems like spicetify has already been installed, but you haven't reloaded your shell"
  echo "Please do so before re-running this script. Skipping..."
  return
fi

if ! doesDirExist "$SPICE_DIR" && ! isProgramInstalled spicetify; then
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
  echo -e "Install complete\n"

  echo "Setting up foundation for spicetify components..."
  mkdir "$SPICE_CONFIG_DIR/CustomApps"
  mkdir "$SPICE_CONFIG_DIR/Themes"
  mkdir "$SPICE_CONFIG_DIR/Extensions"

  echo "Spicetify installation complete. A shell reload is required for the changes to take effect. On the next run, this script will install some themes and the marketplace."
  echo "Cannot source zsh from bash script"
  echo "Make sure to include any custom color schemes to the relevant theme files afterwards"
  echo "Reloading shell..."

  #shellcheck source=/dev/null
  exit 0
fi

echo "Configuring spicetify installation..."

echo "Installing spicetify themes..."
# Install steps can be found here: https://github.com/spicetify/spicetify-themes
if ! doesDirExist "$SPICE_CONFIG_DIR/Themes/Sleek"; then
  git clone https://github.com/spicetify/spicetify-themes.git
  cp -a spicetify-themes/. "$SPICE_CONFIG_DIR/Themes"
  echo "Themes successfully installed!"
else
  echo "Spicetify themes have already been installed. Skipping..."
fi
echo -e "\n"

echo "Installing marketplace for custom apps..."
prefsFilePath="$HOME/.var/app/com.spotify.Client/config/spotify/prefs"

if ! doesFileExist "$prefsFilePath"; then
  echo "We will need an existing Spotify prefs path before the marketplace can be installed"
  echo "Dont't worry you don't have to do much, nor do you need to manually create it"
  echo "All you gotta do is open the Spotify app once for a bit before you re-run the script. Skipping for now..."
  return
fi

# Install steps can be found here: https://spicetify.app/docs/getting-started#basic-usage
if ! doesDirExist "$SPICE_CONFIG_DIR/CustomApps/marketplace"; then
  curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
  echo "Marketplace successfully installed!"
  echo "All spicetify components have been installed!"
else
  echo "Spicetify marketplace has already been installed. Skipping..."
fi
