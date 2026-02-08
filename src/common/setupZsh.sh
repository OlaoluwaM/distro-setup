#!/usr/bin/env bash

# Set ZSH as default shell

echo "Setting ZSH as default shell..."

if ! isProgramInstalled zsh; then
  echo "Zsh is needed before we can set it as the default login shell"
  echo "Please install it then re-run this script. Exiting..."
  exit 1
fi

export DOTS_DIR="$HOME/Desktop/dotfiles/fedora/.config"

if [[ $SHELL == *"zsh" ]]; then
  echo "Seems like ZSH is already the default loging shell. Skipping..."
  return
fi

if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
  echo -e "It seems zsh is not amongst your list of authorized shells. Adding it...\c"
  which zsh | sudo tee -a /etc/shells &>/dev/null
  echo -e "Done!\n"
fi

echo -e "Creating placeholder .zshrc file...\c"
touch "$HOME/.zshrc"

# shellcheck disable=SC2154
cat "$commonScriptsDir/assets/placeholder_zshrc" >"$HOME/.zshrc"
echo -e "Done!\n"

echo "Switching login shell to ZSH..."
chsh -s "$(which zsh)"
echo -e "Done!\n"

echo "Zsh is now the default shell! Script will now exit. You may need to logout and log back in to see the effects. After doing so, re-run this script"
exit 0
