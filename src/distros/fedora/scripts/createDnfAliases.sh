#!/usr/bin/env bash

# Restore dnf command aliases
# Depends on: Dotfiles initialization

if isDirEmpty "$HOME/Desktop/olaolu_dev/dotfiles"; then
  echo "You will need to clone the dotfiles repository from Github before running this script. Skipping..."
  return
fi

# If $DOTFILES variable is unset, skip this script because dotfiles have not been symlinked yet
if [[ -v "${DOTFILESS+x}" ]]; then
  echo "You'll need to symlink your dotfiles before running this script. Skipping..."
  return
fi

echo "Settting up dnf aliases..."
DNF_ALIASES="$DOTFILES/system/dnf-alias.txt"

while read -r line; do
  IFS="=" read -r aliasStr cmdStr <<<"$line"
  sudo dnf alias add "$aliasStr"="$cmdStr"
done <"$DNF_ALIASES"

echo "dnf aliases successfully registered"
