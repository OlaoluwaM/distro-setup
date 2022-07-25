#!/usr/bin/env bash

# Run once dotfiles have been installed
DNF_ALIASES="$DOTFILES/system/dnf-alias.txt"

while read -r line; do
  IFS="=" read -r aliasStr cmdStr <<<"$line"
  sudo dnf alias add "$aliasStr"="$cmdStr"
done <"$DNF_ALIASES"
printf "\n"
