#!/usr/bin/env bash

if ! command -v gh &>/dev/null || [[ $(
  ssh -T git@github.com
  echo $?
) -gt 1 ]]; then
  echo "Either the Github CLI is yet to be setup or you are yet to connect to github via ssh"
  return
fi
printf "\n"

# Should be run after shell aliases are set
GH_EXT_LIST="$DOTFILES/git/gh-extensions.txt"

while read -r extensionName; do
  echo "Installing $extensionName"
  ! (gh extension list | grep "$extensionName") &>/dev/null && gh extension install "$extensionName"
  echo "$extensionName Installed!"
  printf "\n"
done <"$GH_EXT_LIST"
