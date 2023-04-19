#!/usr/bin/env bash

themesDir="$HOME/.themes"

GTK_THEME_NAME="Catppucin-Mocha-Lavender-Dark"
themeDir="$themesDir/$GTK_THEME_NAME"

if doesDirExist "$themeDir"; then
  echo "Looks like we've already installed the $GTK_THEME_NAME theme. Skipping..."
  return
fi

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
previousWorkingDirectory="$(pwd)"

cd "$HOME/catppuccin-gtk" || exit
virtualenv -p python3 venv # to be created only once and only if you need a virtual env

# shellcheck source=/dev/null
source venv/bin/activate
pip install -r requirements.txt
echo -e "Done!\n"

echo "Installing Lavender mocha theme"
python install.py mocha -a lavender -n "$GTK_THEME_NAME" -d "$HOME/.themes"
echo -e "Done!\n"

# From my shell_env file
echo -e "Setting flatpak theme..."
sudo flatpak override --env=GTK_THEME="$GTK_THEME_NAME"
echo -e "Done!\n"

echo "Linking gtk-4.0 contents to ~/.config/gtk-4.0/ dir to theme other more stubborn applications..."
ln -svf $themeDir/gtk-4.0/* "$HOME/.config/gtk-4.0/"
echo -e "Done!\n"

echo "Adding padding to terminals..."
stylesPath="$HOME/.config/gtk-3.0/gtk.css"

cat <<EOF >>"$stylesPath"

  VteTerminal,
  TerminalScreen,
  vte-terminal {
      padding: 4px 16px 10px 16px;
      -VteTerminal-inner-border: 4px 16px 10px 16px;
  }
EOF
echo -e "Done!\n"

cd "$previousWorkingDirectory" || exit

echo "Removing artifacts..."
rm -rf "$HOME/catppuccin-gtk"
echo "Done"
