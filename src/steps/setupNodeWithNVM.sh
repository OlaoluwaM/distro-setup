#!/usr/bin/env bash

# Install NVM and use it to setup both Node and NPM
# Requirements: curl, zsh
# https://github.com/nvm-sh/nvm

echo "Installing NVM and setting up Node and NPM"

if ! isProgramInstalled curl || ! isProgramInstalled wget || ! isProgramInstalled zsh; then
	echo "You need curl, wget, and zsh to install NVM."
	skipStep "Please install the missing dependency, then re-run this script to install Node and NPM."
	return
fi

if [ -z "$NVM_DIR" ]; then
	export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
	success "NVM_DIR set to $NVM_DIR for this script"
fi

# We use `doesDirExist "$NVM_DIR"` instead of `isProgramInstalled nvm` to check if nvm is installed because of some strange issue
# Where `command -v nvm` doesn't work while the script is running, but does work after it exits
if doesDirExist "$NVM_DIR" && isProgramInstalled node && isProgramInstalled npm && isProgramInstalled pnpm; then
	alreadyDone "NVM, Node, NPM, and PNPM are installed"
	return
fi

if ! doesDirExist "$NVM_DIR"; then
	echo "Installing NVM..."
	if ! wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash; then
		failSetup "Could not install NVM."
	fi

	echo -e "\n"
	success "NVM installed"
	echo "Reloading your login shell to get NVM up and running..."
	pauseForRerun "NVM has been installed."
fi

if ! doesDirExist "$NVM_DIR"; then
	echo "Seems there was an issue with the NVM installation"
	echo "NVM is needed to install node"
	failSetup "You may have to source the .zshrc file manually to continue with this script."
fi

if doesDirExist "$NVM_DIR" && (! isProgramInstalled node || ! isProgramInstalled npm || ! isProgramInstalled pnpm); then
	# shellcheck source=/dev/null
	if doesFileExist "$NVM_DIR/nvm.sh"; then
		. "$NVM_DIR/nvm.sh"
	else
		failSetup "Could not find $NVM_DIR/nvm.sh to load NVM."
	fi

	echo "Installing Node & latest NPM..."
	runOrFail "Could not install Node with NVM." nvm install --latest-npm node
	echo -e "\n"
	success "Node and NPM installed"

	echo "Great! Both NPM and Node have been installed"
	echo "Node version is $(node -v)"
	echo "NPM version is $(npm -v)"
	echo -e "\n"

	echo "Checking NPM installation..."
	runOrWarn "npm doctor reported issues." npm doctor
	echo -e "\n"

	echo "Installing pnpm..."
	runOrFail "Could not install corepack." npm install -g corepack@latest # To fix issue with outdated signatures https://pnpm.io/installation
	sleep 2
	runOrFail "Could not enable corepack." corepack enable
	runOrFail "Could not activate pnpm." corepack prepare pnpm@latest-11 --activate
	sleep 2
	runOrFail "pnpm was installed, but could not be run." pnpm --version
	success "pnpm installed"
fi
