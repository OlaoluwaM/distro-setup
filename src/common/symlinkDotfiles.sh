#!/usr/bin/env bash

# Symlink dotfiles
# Requirements: Node, NPM, Global NPM packages, Cloned dotfiles repo
# Depends on: NPM install, Global NPM packages install, Cloning repos from github

# If `dfs` is installed then Node & NPM must be installed as well since you cannot install dfs without NPM and NPM comes with Node
if ! isProgramInstalled dfs; then
  echo "dfs (dotfilers CLI) is required to symlink your dotfiles"
  echo "Please install it from NPM (npm i -g dotfilers) before trying again"
  exit 1
fi

if isDirEmpty "$HOME/Desktop/olaolu_dev/dotfiles"; then
  echo "You will need to clone the dotfiles repository from Github before your dotfiles can be symlinked"
  exit 1
fi

if doesFileExist "$HOME/.gitconfig" && doesFileExist "$HOME/powerline-test.sh" && doesFileExist "$HOME/.bash_aliases"; then
  echo "Dotfiles have already been symlinked!"
  return
fi

echo "Creating symlinks for dotfiles..."
dfs ln --yes
echo "Symlinks created!"
echo "Reloading zsh..."
exec zsh
