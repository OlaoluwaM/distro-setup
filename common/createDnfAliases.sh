#!/usr/bin/env bash

echo "Settting up dnf aliases..."
# Run once dotfiles have been installed
DNF_ALIASES="$DOTFILES/system/dnf-alias.txt"

while read -r line; do
  IFS="=" read -r aliasStr cmdStr <<<"$line"
  sudo dnf alias add "$aliasStr"="$cmdStr"
done <"$DNF_ALIASES"

echo "dnf aliases successfully registered"
printf "\n"
