#!/usr/bin/env bash

# Install NVM and use it to setup both Node and NPM
# Requirements: curl, zsh

echo "Installing NVM and setting up Node and NPM..."

if ! isProgramInstalled curl || ! isProgramInstalled zsh; then
  echo "You need to install BOTH curl and zsh to install NVM."
  echo "Please do so, then re-run this script to install Node & NPM. Exiting..."
  exit 1
fi

if isProgramInstalled nvm && isProgramInstalled node && isProgramInstalled npm; then
  echo "NVM, Node, and NPM have already been installed. Moving on..."
  return
fi

if ! doesDirExist "$HOME/.nvm"; then
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  echo "NVM installed successfully!"

  echo "Reloading your login shell to get NVM up and running..."
  echo "Once this is done, re-run the script"
  exec zsh
fi

if ! isProgramInstalled nvm; then
  echo "Seems there was an issue with the NVM installation"
  echo "NVM is needed to install node"
  echo "You may have to source the .zshrc file manually to continue with this script. Exiting..."
  exit 1
fi

if isProgramInstalled nvm && ! isProgramInstalled node; then
  # shellcheck source=/dev/null
  . "$HOME/.zshrc"

  echo "Installing Node & NPM..."
  nvm install node
  echo "Successfully installed Node & NPM"

  echo "Upgrading NPM to latest version..."
  npm up -g npm
  echo "Done!"

  echo "Great! Both NPM and Node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"

  echo "Checking NPM installation..."
  npm doctor
  echo "Done!"
fi
