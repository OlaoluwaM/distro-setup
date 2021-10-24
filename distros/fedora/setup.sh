#!/usr/bin/env bash

sudo dnf update -y
rootDir=$(dirname "$(dirname "$(dirname "$0")")")

source "$rootDir/common/isInstalled.sh"

# Install and setup oh-my-zsh and zsh
# Install ZSH

if [ "$(isNotInstalled "zsh --version")" ]; then
  echo "Installing ZSH"
  sudo dnf install zsh
  echo "Done installing ZSH"
fi

# Set ZSH to default terminal
if [[ $SHELL != *"zsh" ]]; then
  echo "Setting ZSH as default shell"

  if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
    echo "It seems zsh is not amongst your list of authorized shells. Adding it"
    sudo echo "$(which zsh)" >>/etc/shells
    echo "Done!"
  fi

  chsh -s "$(which zsh)"
  echo "Done! You may need to logout and log back in to see the effects"
fi

# Install Oh-My-ZSH
# First check for either the curl or wget commands
if [ "$(isNotInstalled "command -v curl")" ] && [ "$(isNotInstalled "command -v wget")" ]; then
  echo "You need to install either curl or wget in order to install oh-my-zsh"
  sudo dnf install wget curl -y
fi

source "$rootDir/common/intallOMZ.sh"

# Install Git
if [ "$(isNotInstalled "command -v git")" ]; then
  echo "Seems like you do not have git installed :/"
  sudo dnf install git-all -y

else
  echo "Seems you already have git installed"
fi

source "$rootDir/common/exposeENV.sh"
exposeEnvValues "./.env"

# Install Github CLI
if [ "$(isNotInstalled "command -v gh")" ]; then
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  echo "Installed Github CLI"

  if [[ ! $(gh auth status) =~ $Token ]]; then
    echo "Seems like you are not authenticated :(. Let's fix that"

    echo "$GH_TOKEN" >gh_token.txt
    gh auth login --with-token <gh_token.txt

    unset GH_TOKEN
    rm gh_token.txt

    echo "Now you are :)"
  fi

  # Install gh extensins
fi

# Install nvm
if [ "$(isNotInstalled "command -v nvm")" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  source "~/.zshrc"
fi

if [ "$(isNotInstalled "command -v nvm")" ]; then
  echo "Seems there is an issue with the nvm installation"
  echo "You may have to source the .zshrc file manually or something"
  exit 4
fi

# Install node
if [ "$(isNotInstalled "command -v nvm")" ]; then
  echo "nvm is needed to install node"
  exit 4
fi

if [ "$(isNotInstalled "command -v nvm")" ]; then
  nvm install node
fi

if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  echo "Great! Both npm and node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"
  echo "Checking npm installation...."
  npm doctor
fi

# Install global node packages
if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  npm i -g spaceship typescript ts-node @types/node ntl term-of-the-day @bitwarden/cli fkill-cli serve netlify-cli
fi

# Install certain packages on fedora
# TODO there are some more packages
sudo dnf install -y protonvpn protonvpn-cli speedtest-cli android-tools emoji-picker expect neofetch gnome-tweaks google-chrome
