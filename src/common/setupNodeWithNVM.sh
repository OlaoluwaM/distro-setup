#!/usr/bin/env bash

# Install NVM and use it to setup both Node and NPM
# Requirements: curl, zsh
# https://github.com/nvm-sh/nvm

echo "Installing NVM and setting up Node and NPM"

if ! isProgramInstalled curl || ! isProgramInstalled zsh; then
	echo "You need to install BOTH curl and zsh to install NVM."
	echo "Please do so, then re-run this script to install Node & NPM. Exiting..."
	exit 1
fi

if [ -z "$NVM_DIR" ]; then
	echo -n "Setting NVM_DIR to $XDG_CONFIG_HOME/nvm for the purpose of this script..."
	export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
	echo -e "Done\n"
fi

# We use `doesDirExist "$NVM_DIR"` instead of `isProgramInstalled nvm` to check if nvm is installed because of some strange issue
# Where `command -v nvm` doesn't work while the script is running, but does work after it exits
if doesDirExist "$NVM_DIR" && isProgramInstalled node && isProgramInstalled npm && isProgramInstalled pnpm; then
	echo "NVM, Node, NPM, and PNPM have already been installed. Moving on..."
	return
fi

if ! doesDirExist "$NVM_DIR"; then
	echo "Installing NVM..."
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

	echo -e "\nNVM installed successfully!"
	echo "Reloading your login shell to get NVM up and running..."
	echo "Once this is done, re-run the script. Exiting..."
	exit 0
fi

if ! doesDirExist "$NVM_DIR"; then
	echo "Seems there was an issue with the NVM installation"
	echo "NVM is needed to install node"
	echo "You may have to source the .zshrc file manually to continue with this script. Exiting..."
	exit 1
fi

if doesDirExist "$NVM_DIR" && (! isProgramInstalled node || ! isProgramInstalled pnpm); then
	# shellcheck source=/dev/null
	. "$HOME/.zshrc"

	echo "Installing Node & latest NPM..."
	nvm install --latest-npm node
	echo -e "Successfully installed Node & NPM\n"

	echo "Great! Both NPM and Node have been installed"
	echo "Node version is $(node -v)"
	echo "NPM version is $(npm -v)"
	echo -e "\n"

	echo "Checking NPM installation..."
	npm doctor
	echo -e "Done!\n"

	echo "Installing pnpm..."
	npm install -g corepack@latest # To fix issue with outdated signatures https://pnpm.io/installation
	sleep 2
	corepack enable
	corepack prepare pnpm@latest-10 --activate
	sleep 2
	pnpm --version
	echo "Done!"
fi
