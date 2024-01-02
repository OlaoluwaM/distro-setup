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

function other_dir_setup_reminder() {
  echo "Note that the following directories did not get symlinked in the previous step and will instead require you to run a 'setup.sh link' within each of their directories"
  echo "The directories are:"
  echo "  ags"
  echo "  hypr"
  echo "  wlogout"
  echo "  ulauncher"
}

if doesFileExist "$HOME/.gitconfig" && doesFileExist "$HOME/powerline-test.sh" && [[ -n "${DEV+x}" ]] && [[ -n "${CUSTOM_BIN_DIR+x}" ]] && doesFileExist "$HOME/.shell-env"; then
  if [[ "$DOTS" != "$DOTS_DIR" ]]; then
    echo "Please update the value of the DOTS variable in $HOME/.shell-env to $DOTS_DIR"
    echo "Same for DEV. Update DEV to $HOME/Desktop/labs"
    echo "Then re-run this script. Exiting..."
    exit 1
  fi
  # other_dir_setup_reminder
  return
fi

if ! doesFileExist "$HOME/.shell-env"; then
  echo "We need the environment variables defined in the file $HOME/.shell-env, to correctly link other config groups"
  echo "We will do that first..."
  dfs ln shell
  echo "Done! The script will now exit. Please rerun it"
  exit 0
fi

dfs ln --yes
echo -e "Symlinks created!\n"

# other_dir_setup_reminder

echo "Reloading zsh..."
exec zsh
