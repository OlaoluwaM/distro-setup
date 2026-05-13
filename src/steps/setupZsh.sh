#!/usr/bin/env bash

# Set ZSH as default shell

echo "Setting ZSH as default shell..."

if ! isProgramInstalled zsh; then
	echo "Zsh is needed before we can set it as the default login shell"
	skipStep "Please install it, then re-run this script."
	return
fi

zshPath="$(command -v zsh)"
currentLoginShell="$(getent passwd "$USER" | cut -d: -f7)"

if [[ "$(basename "$currentLoginShell")" == "zsh" ]]; then
	alreadyDone "Zsh is the default login shell"
	return
fi

if ! grep -Fxq "$zshPath" /etc/shells; then
	echo -e "It seems zsh is not amongst your list of authorized shells. Adding it...\c"
	if ! echo "$zshPath" | sudo tee -a /etc/shells &>/dev/null; then
		failSetup "Could not add $zshPath to /etc/shells."
	fi
	echo -e "\n"
	success "$zshPath added to /etc/shells"
fi

if ! doesFileExist "$HOME/.zshrc"; then
	echo -e "Creating .zshrc file...\c"
	runOrFail "Could not create $HOME/.zshrc." touch "$HOME/.zshrc"
	echo -e "\n"
	success ".zshrc created"
else
	alreadyDone "$HOME/.zshrc exists"
fi

echo "Switching login shell to ZSH..."
runOrFail "Could not switch login shell to $zshPath." chsh -s "$zshPath"
echo -e "\n"
success "Login shell switched to Zsh"

pauseForRerun "Zsh is now the default shell. You may need to log out and log back in before continuing."
