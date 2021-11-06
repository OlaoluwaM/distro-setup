#!/usr/bin/env bash

if [ -d "$HOME/Desktop/olaolu_dev/dotfiles" ]; then
  echo "Creating symlinks for dotfiles"
  node "$HOME/Desktop/olaolu_dev/dotfiles/makeSymlinks.js"
  echo "Symlinks created"
else
  echo "Looks like you are yet to pull down your dotfiles repo"
  exit 1
fi
printf "\n"
