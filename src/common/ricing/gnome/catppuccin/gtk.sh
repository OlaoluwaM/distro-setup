#!/usr/bin/env bash

if ! isProgramInstalled git || ! isProgramInstalled pip3; then
  echo "To run the gnome setup script, please install both python (>= v3.10) and git"
  return
fi

if [[ -z ${DEV+x} ]]; then
  echo "This script will require the use of some shell functions defined in our dotfiles"
  echo "https://github.com/OlaoluwaM/dotfiles/blob/master/shell/.shell_env#L278"
  return
fi

echo "Customing Gnome & Flatpaks with Catppuccin theme"
echo "Cloning repo for Catppuccin GTK theme"
# https://github.com/catppuccin/gtk

git clone --recurse-submodules git@github.com:catppuccin/gtk.git "$HOME/catppuccin-gtk"
cd "$HOME/catppuccin-gtk" || exit
virtualenv -p python3 venv # to be created only once and only if you need a virtual env

# shellcheck source=/dev/null
source venv/bin/activate
pip install -r requirements.txt
echo -e "\n"

echo "Installing Lavender mocha theme"

GTK_THEME_NAME="Catppucin Mocha Lavender"
python3 install.sh mocha -a lavender -n "$GTK_THEME_NAME" -d "$HOME/.themes"
echo -e "\n"

echo "Updating Gnome theme. This also includes the theme for flatpaks"
updateGnomeTheme "$GTK_THEME_NAME"
