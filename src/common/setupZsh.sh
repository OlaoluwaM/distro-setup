#!/usr/bin/env bash

# Set ZSH as default shell
# Requirements: zsh

echo "Setting ZSH as default shell..."

if ! isProgramInstalled zsh; then
  echo "Zsh is needed before we can set it as the default login shell"
  echo "Please install it then re-run this script. Exiting..."
  exit 1
fi

export DOTS_DIR="$HOME/Desktop/olaolu_dev/dotfiles"

if [[ $SHELL == *"zsh" ]]; then
  echo "Seems like ZSH is already the default loging shell. Skipping..."
  return
fi

if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
  echo "It seems zsh is not amongst your list of authorized shells. Adding it...\c"
  which zsh | sudo tee -a /etc/shells &>/dev/null
  echo "Done!"
fi

echo "Creating placeholder .zshrc file..."
touch "$HOME/.zshrc"
echo -e "# This is a placeholder file\n" >"$HOME/.zshrc"
echo "export DOTS=$DOTS_DIR" >>"$HOME/.zshrc"
echo "Done!"

echo "Switching login shell to ZSH..."
chsh -s "$(which zsh)"
echo "Done!"

echo "Zsh is now the default shell! Script will now exit. You may need to logout and log back in to see the effects. After doing so, re-run this script"
exit 0
