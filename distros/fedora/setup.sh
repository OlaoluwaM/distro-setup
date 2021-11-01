#!/usr/bin/env bash

rootDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
source "$rootDir/common/isInstalled.sh"

sudo dnf update -y

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
  echo "Installed curl and wget, just in case..."
fi

source "$rootDir/common/intallOMZ.sh"

# Install Git
if [ "$(isNotInstalled "command -v git")" ]; then
  echo "Seems like you do not have git installed :/"
  sudo dnf install git-all -y

  echo "Git successfully installed"
else
  echo "Seems you already have git installed"
fi

source "$rootDir/common/exposeENV.sh"
exposeEnvValues "./.env"

# Install Github CLI
if [ "$(isNotInstalled "command -v gh")" ]; then
  echo "Installing Github CLI. Setting things up...."
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  echo "Installed Github CLI"

  if [[ ! $(gh auth status) =~ $Token ]]; then
    echo "Seems like you are not authenticated :(. Let's fix that"

    # Alternate Method
    # echo "export GH_TOKEN=$GH_TOKEN" >"$HOME/.personal_token"

    echo "$GH_TOKEN" >"gh_token.txt"
    gh auth login --with-token <gh_token.txt

    unset GH_TOKEN
    rm gh_token.txt

    echo "Now you are :)"
  fi

  # Install gh extensins
  echo "Installing some gh CLI extensions"

  echo "Installing screensaver extension"
  [ "$(isNotInstalled "gh extension list | grep 'vilmibm/gh-screensaver'")" ] && gh extension install vilmibm/gh-screensaver
  echo "Screensaver extension installed"

  echo "Installing extension that allows you to delete repos from commandline"
  [ "$(isNotInstalled "gh extension list | grep 'mislav/gh-delete-repo'")" ] && gh extension install mislav/gh-delete-repo
  echo "gh-delete-repo extension installed"

  echo "Installing extension for viewing contribution graph"
  [ "$(isNotInstalled "gh extension list | grep 'kawarimidoll/gh-graph'")" ] && gh extension install kawarimidoll/gh-graph
  echo "Extension for viewing contribution graph installed"
fi

# Create desired filesystem structure
source "$rootDir/common/createDirStructure.sh"

# Install nvm
if [ "$(isNotInstalled "command -v nvm")" ]; then
  echo "Installing nmv..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  source "~/.zshrc"

  echo "NVM installed successfully, and .zshrc file reloaded"
fi

if [ "$(isNotInstalled "command -v nvm")" ]; then
  echo "Seems there is an issue with the nvm installation"
  echo "nvm is needed to install node"
  echo "You may have to source the .zshrc file manually or something"
  exit 4
fi

# Install node
if [ "$(isInstalled "command -v nvm")" ]; then
  echo "Installing Node & NPM"
  nvm install node
  echo "Successfully installed Node & NPM"
fi

if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  echo "Great! Both npm and node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"
  echo "Checking npm installation...."
  npm doctor
fi

# Install global node packages
source "$rootDir/common/installGlobalNpmPackages.sh"

# Install certain packages on fedora
# TODO there are some more packages

echo "Installing some linux packages"
sudo dnf install -y protonvpn protonvpn-cli speedtest-cli android-tools emoji-picker expect neofetch gnome-tweaks google-chrome hw-probe python3-pip snapd
echo "Installed."

# Setup Flathub and install certain flatpaks
source "$rootDir/common/setupFlathub.sh"

# Setup Snapcraft and install some snaps
source "$rootDir/common/setupSnapcraft.sh"

# Install some miscellaneous CLIs wit pip
source "$rootDir/common/installMisc.sh"

# Clone repos
source "$rootDir/common/cloneGitRepos.sh"

# Create symlinks for dotfiles
source "$rootDir/common/symlinkDotfiles.sh"
