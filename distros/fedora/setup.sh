#!/usr/bin/env bash

rootDir=$(dirname "$(dirname "$(dirname "$0")")")

# Install and setup oh-my-zsh and zsh
# Install ZSH

if [ "$(
  zsh -version &>/dev/null
  echo $?
)" -gt 0 ]; then
  echo "Installing ZSH"
  sudo dnf update -y
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
source "$rootDir/common/intallOMZ.sh"
