#!/usr/bin/env bash

icons_dir="$HOME/.local/share/icons"

icon_name="Colloid-dark"
path_to_icon="$icons_dir/$icon_name"

if doesDirExist "$path_to_icon"; then
  echo "Looks like we've already installed the Colloid icon theme. Skipping..."
  return
fi

if ! isProgramInstalled gh; then
  echo "To run the Colloid icon setup script, please install the GitHub CLI"
  return
fi

if [[ -z ${DEV+x} ]]; then
  echo "This script will require the use of some shell functions defined in our dotfiles"
  echo "https://github.com/OlaoluwaM/dotfiles/blob/master/shell/.shell_env#L278"
  return
fi

echo "Cloning repo for Colloid icon theme..."
# https://github.com/vinceliuice/Colloid-icon-theme

gh repo clone vinceliuice/Colloid-icon-theme "$HOME/colloid"
previousWorkingDirectory="$(pwd)"

echo "Installing icons..."
cd "$HOME/colloid" || exit
./install.sh -d "$icons_dir" -s default -t default
echo -e "Done!\n"

cd "$previousWorkingDirectory" || exit

echo "Removing artifacts..."
rm -rf "$HOME/colloid"
echo "Done"
