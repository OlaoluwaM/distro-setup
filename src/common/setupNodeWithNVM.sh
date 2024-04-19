#!/usr/bin/env bash

# Install NVM and use it to setup both Node and NPM
# Requirements: curl, zsh

echo "Installing NVM and setting up Node and NPM"

if ! isProgramInstalled curl || ! isProgramInstalled zsh; then
  echo "You need to install BOTH curl and zsh to install NVM."
  echo "Please do so, then re-run this script to install Node & NPM. Exiting..."
  exit 1
fi

# We use `doesDirExist "$HOME/.nvm"` instead of `isProgramInstalled nvm` to check if nvm is installed because of some strange issue
# Where `command -v nvm` doesn't work while the script is running, but does work after it exits
if doesDirExist "$HOME/.nvm" && isProgramInstalled node && isProgramInstalled npm; then
  echo "NVM, Node, and NPM have already been installed. Moving on..."
  return
fi

if ! doesDirExist "$HOME/.nvm"; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

  echo -e "\nNVM installed successfully!"
  echo "Reloading your login shell to get NVM up and running..."
  echo "Once this is done, re-run the script. Exiting..."
  exit 0
fi

if ! doesDirExist "$HOME/.nvm"; then
  echo "Seems there was an issue with the NVM installation"
  echo "NVM is needed to install node"
  echo "You may have to source the .zshrc file manually to continue with this script. Exiting..."
  exit 1
fi

if doesDirExist "$HOME/.nvm" && ! isProgramInstalled node; then
  # shellcheck source=/dev/null
  . "$HOME/.zshrc"

  echo "Installing Node & NPM..."
  nvm install --latest-npm node
  echo -e "Successfully installed Node & NPM\n"

  echo "Upgrading NPM to latest version..."
  npm up -g npm
  echo -e "Done!\n"

  echo "Great! Both NPM and Node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"
  echo -e "\n"

  echo "Checking NPM installation..."
  npm doctor
  echo "Done!"

  echo "Installing pnpm..."
  corepack enable
  corepack prepare pnpm@latest --activate
  sleep 2
  echo "Done!"
fi
