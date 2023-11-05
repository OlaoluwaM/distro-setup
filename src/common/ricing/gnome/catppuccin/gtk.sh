#!/usr/bin/env bash

themes_dir="$HOME/.local/share/themes"

theme_name="Catppuccin-Mocha-Standard-Lavender-Dark"
path_to_gtk_theme="$themes_dir/$theme_name"

if doesDirExist "$path_to_gtk_theme"; then
  echo "Looks like we've already installed the $theme_name theme. Skipping..."
  return
fi

# The reason we aren't using gh is because the README in the catppuccin-gtk repos uses git
if ! isProgramInstalled git || ! isProgramInstalled pip3; then
  echo "To run the gnome setup script, please install both python (>= v3.10) and git"
  return
fi

if [[ -z ${DEV+x} ]]; then
  echo "This script will require the use of some shell functions defined in our dotfiles"
  echo "https://github.com/OlaoluwaM/dotfiles/blob/master/shell/.shell_env#L278"
  return
fi

echo "Cloning repo for Catppuccin GTK theme"
# https://github.com/catppuccin/gtk

if ! doesDirExist "$HOME/.config/gtk-4.0/"; then
  mkdir -p "$HOME/.config/gtk-4.0/"
fi

git clone --recurse-submodules git@github.com:catppuccin/gtk.git "$HOME/catppuccin-gtk"
previousWorkingDirectory="$(pwd)"

cd "$HOME/catppuccin-gtk" || exit
virtualenv -p python3 venv # to be created only once and only if you need a virtual env

# shellcheck source=/dev/null
source venv/bin/activate
pip install -r requirements.txt

echo "Installing Lavender mocha theme"
python install.py mocha -a lavender -d "$themes_dir" -l
echo -e "Done!\n"

# From my shell_env file
echo -e "Setting flatpak theme..."
sudo flatpak override --env=GTK_THEME="$theme_name"
echo -e "Done!\n"

cd "$previousWorkingDirectory" || exit

echo "Setting GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme "$theme_name"
echo -e "Done!\n"
echo "However, we will need to install and enable the 'User Themes' extension for this to take effect on the Gnome Shell"

echo "Removing artifacts..."
rm -rf "$HOME/catppuccin-gtk"
echo "Done"
