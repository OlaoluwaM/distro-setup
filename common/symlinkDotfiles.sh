#!/usr/bin/env bash

# Requires node and dotfiles repo from my github

if [ -d "$HOME/Desktop/olaolu_dev/dotfiles" ] && command -v node &>/dev/null; then
  echo "Creating symlinks for dotfiles"
  node "$HOME/Desktop/olaolu_dev/dotfiles/makeSymlinks.js"
  echo "Symlinks created"
else
  echo "Looks like you are yet to pull down your dotfiles repo. Or maybe Node isn't installed?"
  exit 1
fi
printf "\n"
