#!/usr/bin/env bash

# Install extensions for the Github CLI
# Requirements: The Github CLI, dotfiles

echo "Installing extensions for the Github CLI..."

if ! isProgramInstalled gh; then
  echo "We need the Github CLI to be installed before we can install any extensions"
  echo "Please install it then re-run this script. Skipping..."
  return
fi

if [[ $(
  ssh -T git@github.com &>/dev/null
  echo $?
) -eq 1 ]]; then
  echo "You'll need a valid SSH connection to GitHub before we can install any extensions for the CLI"
  echo "Please set this up then re-run this script. Skipping..."
  return
fi

# Should be run after shell aliases are set
GH_EXT_LIST="$DOTS_DIR/git/gh-extensions.txt"

if ! doesFileExist "$GH_EXT_LIST"; then
  echo "The file containing the list of CLI extensions to install cannot be found. The path to the file ($GH_EXT_LIST) might not exist"
  echo "Please create and populate this file then re-run this script. Skipping..."
  return
fi

while read -r extensionName; do

  if ! gh extension list | grep "$extensionName" &>/dev/null; then
    gh extension install "$extensionName"
    echo "$extensionName has been installed!"
  else
    echo "$extensionName has already been installed"
  fi

  echo -e "\n"
done <"$GH_EXT_LIST"

echo "Github CLI extensions installed successfully"
