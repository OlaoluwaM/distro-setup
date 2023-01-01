#!/usr/bin/env bash

# Install extensions for the Github CLI
# Requirements: The Github CLI, dotfiles

echo "Installing extensions for the Github CLI..."

if ! isProgramInstalled gh; then
  echo "We need the Github CLI to be installed before we can install any extensions"
  echo "Please install it then re-run this script. Skipping..."
  return
fi

ssh -T git@github.com &>/dev/null
GIT_AUTH_STATUS_CHECK_EXIT_CODE_TWO="$?"

if [[ $GIT_AUTH_STATUS_CHECK_EXIT_CODE_TWO -ne 1 ]]; then
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
  echo "Installing $extensionName..."
  ! (gh extension list | grep "$extensionName") &>/dev/null && gh extension install "$extensionName"
  echo "$extensionName Installed!"
done <"$GH_EXT_LIST"

echo "Github CLI extensions installed successfully"
