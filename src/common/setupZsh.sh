#!/usr/bin/env bash

# Set ZSH as default shell
# Requirements: zsh

if ! isProgramInstalled zsh; then
  echo "Please install zsh before running this script"
  exit 1
fi

if [[ $SHELL == *"zsh" ]]; then
  echo "Seems like ZSH is already the default shell"
  return
fi

echo "Setting ZSH as default shell..."

if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
  echo "It seems zsh is not amongst your list of authorized shells. Adding it...\c"
  which zsh | sudo tee -a /etc/shells &>/dev/null
  echo "Done!"
fi

echo "Creating placeholder .zshrc file...\c"
touch "$HOME/.zshrc"
echo "# This is a placeholder file" >"$HOME/.zshrc"
echo -e "\nexport DOTS=$HOME/Desktop/olaolu_dev/dotfiles" >>"$HOME/.zshrc"
echo "Done!"

echo "Switching login shell to ZSH...\c"
chsh -s "$(which zsh)"
echo "Done! You may need to logout and log back in to see the effects"
exit 0
