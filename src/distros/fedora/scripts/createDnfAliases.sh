#!/usr/bin/env bash

# Restore dnf command aliases
# Depends on: Dotfiles initialization

echo "Settting up dnf aliases..."

DNF_ALIASES="$DOTS_DIR/system/dnf-alias.txt"

if ! doesFileExist "$DNF_ALIASES"; then
  echo "We could not find your dnf aliases to restore. Looks like the file ($DNF_ALIASES) they were supposed to be listed in doesn't exist"
  echo "Please create and populate this file then re-run this script. Skipping..."
  return
fi

while read -r line; do
  IFS="=" read -r aliasStr cmdStr <<<"$line"
  sudo dnf alias add "$aliasStr"="$cmdStr"
done <"$DNF_ALIASES"

echo "dnf aliases successfully registered"
