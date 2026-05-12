#!/usr/bin/env bash

# Symlink dotfiles
# Requirements: Node, NPM, Global NPM packages, Cloned dotfiles repo
# Depends on: NPM install, Global NPM packages install, Cloning repos from github

echo "Creating symlinks for dotfiles..."

# If `dfs` is installed then Node & NPM must be installed as well since you cannot install dfs without NPM and NPM comes with Node
if ! isProgramInstalled dfs; then
	echo "dfs (dotfilers CLI) is required to symlink your dotfiles"
	skipStep "Please install it from NPM (npm i -g dotfilers), then re-run this script."
	return
fi

if ! doesDirExist "$DOTS_DIR"; then
	echo "We cannot find your dotfilers directory. Have you cloned it from Github?"
	skipStep "Please do so first, then re-run this script."
	return
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
	if [[ "${DOTS:-}" != "$DOTS_DIR" ]]; then
		echo "Please update the value of the DOTS variable in $HOME/.shell-env to $DOTS_DIR"
		echo "Same for DEV. Update DEV to $HOME/Desktop/labs"
		failSetup "Dotfile environment variables are out of date."
	fi
	# other_dir_setup_reminder
	return
fi

if ! doesFileExist "$HOME/.shell-env"; then
	echo "We need the environment variables defined in the file $HOME/.shell-env, to correctly link other config groups"
	echo "We will do that first..."
	runOrFail "Could not link shell dotfiles." dfs ln shell
	success "Shell dotfiles linked"
	pauseForRerun "Shell environment variables were linked."
fi

runOrFail "Could not create dotfile symlinks." dfs ln --yes
success "Dotfile symlinks created"
echo -e "\n"

# other_dir_setup_reminder

pauseForRerun "Dotfile symlinks were created. Reload your shell before continuing."
