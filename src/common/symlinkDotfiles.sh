#!/usr/bin/env bash

# Symlink dotfiles
# Requirements: Node, NPM, Global NPM packages, Cloned dotfiles repo
# Depends on: NPM install, Global NPM packages install, Cloning repos from github

echo "Creating symlinks for dotfiles..."

# If `dfs` is installed then Node & NPM must be installed as well since you cannot install dfs without NPM and NPM comes with Node
if ! isProgramInstalled dfs; then
  echo "dfs (dotfilers CLI) is required to symlink your dotfiles"
  echo "Please install it from NPM (npm i -g dotfilers) then re-run this script. Exiting..."
  exit 1
fi

if ! doesDirExist "$DOTS_DIR"; then
  echo "We cannot find your dotfilers directory. Have you cloned it from Github?"
  echo "Please do so first then re-run this script. Exiting..."
  exit 1
fi

if doesFileExist "$HOME/.gitconfig" && doesFileExist "$HOME/powerline-test.sh" && [[ -n "${DEV+x}" ]] && doesFileExist "$HOME/.shell_env"; then
  if [[ "$DOTS" != "$DOTS_DIR" ]]; then
    echo "Please update the value of the DOTS variable in $HOME/.shell_env to $DOTS_DIR"
    echo "Same for DEV. Update DEV to $HOME/Desktop/labs"
    echo "Then re-run this script. Exiting..."
    exit 1
  fi
  echo "Dotfiles have already been symlinked. Moving on..."
  return
fi

dfs ln --yes
echo -e "Symlinks created!\n"

echo "Reloading zsh..."
exec zsh
