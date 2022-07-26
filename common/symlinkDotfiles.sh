#!/usr/bin/env bash

# Requires node and dotfiles repo from my github

if [ -d "$HOME/Desktop/olaolu_dev/dotfiles" ] && [ -v $DEV ] && command -v node &>/dev/null; then
  echo "Creating symlinks for dotfiles"
  node "$HOME/Desktop/olaolu_dev/dotfiles/makeSymlinks.mjs"
  echo "Symlinks created!"

  # Setup spaceship-prompt with npm
  source "$(dirname $(dirname $(dirname $0)))/common/setupSpaceshipPrompt.sh"

  echo "Reloading zsh..."
  exec zsh

elif [ -d "$HOME/Desktop/olaolu_dev/dotfiles" ] && [ ! -v $DEV ]; then
  echo "Looks like dotfiles have already been symlinked"

else
  echo "Looks like you are yet to pull down your dotfiles repo. Or maybe Node isn't installed?"
  exit 1
fi

printf "\n"
