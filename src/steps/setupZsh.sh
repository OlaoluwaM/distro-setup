#!/usr/bin/env bash

# Set ZSH as default shell

echo "Setting ZSH as default shell..."

if ! isProgramInstalled zsh; then
	echo "Zsh is needed before we can set it as the default login shell"
	echo "Please install it then re-run this script."
	return
fi

if [[ $SHELL == *"zsh" ]]; then
	echo "Seems like Zsh is already the default login shell. Skipping..."
	return
fi

zshPath="$(command -v zsh)"

if ! grep -Fxq "$zshPath" /etc/shells; then
	echo -e "It seems zsh is not amongst your list of authorized shells. Adding it...\c"
	echo "$zshPath" | sudo tee -a /etc/shells &>/dev/null
	echo -e "Done!\n"
fi

echo -e "Creating placeholder .zshrc file...\c"
touch "$HOME/.zshrc"

# shellcheck disable=SC2154
cat "$SETUP_ASSETS_DIR/placeholder_zshrc" >"$HOME/.zshrc"
echo -e "Done!\n"

echo "Switching login shell to ZSH..."
chsh -s "$zshPath"
echo -e "Done!\n"

pauseForRerun "Zsh is now the default shell. You may need to log out and log back in before continuing."
