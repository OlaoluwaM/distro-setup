#!/usr/bin/env bash

echo "Attempting to fix the zsh-syntax-highlighting and zsh-autosuggestions plugins"

if ! isProgramInstalled git || ! isGithubSshReady; then
	echo "Git needs to be installed with a valid SSH connection to apply these OMZ plugin fixes"
	skipStep "Please install git and set up a valid SSH connection, then re-run this script."
	return
fi

zshCustomDir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if doesDirExist "$zshCustomDir/plugins/zsh-autosuggestions" &&
	doesDirExist "$zshCustomDir/plugins/fast-syntax-highlighting" &&
	doesDirExist "$zshCustomDir/plugins/you-should-use"; then
	alreadyDone "Zsh plugins are installed"
	return
fi

echo "Fixing zsh-autosuggestions..."
if ! doesDirExist "$zshCustomDir/plugins/zsh-autosuggestions"; then
	runOrFail "Could not clone zsh-autosuggestions." git clone git@github.com:zsh-users/zsh-autosuggestions.git "$zshCustomDir/plugins/zsh-autosuggestions"
	success "zsh-autosuggestions installed"
else
	alreadyDone "zsh-autosuggestions plugin is installed"
fi
echo -e "\n"

# Switching to fsh (fast-syntax-highlighting)
echo "Installing fsh (fast-syntax-highlighting) plugin..."
if ! doesDirExist "$zshCustomDir/plugins/fast-syntax-highlighting"; then
	runOrFail "Could not clone fast-syntax-highlighting." git clone git@github.com:zdharma-continuum/fast-syntax-highlighting.git \
		"$zshCustomDir/plugins/fast-syntax-highlighting"
	success "fast-syntax-highlighting installed"
else
	alreadyDone "fast-syntax-highlighting plugin is installed"
fi
echo -e "\n"

# you-should-use (https://github.com/MichaelAquilina/zsh-you-should-use)
echo "Installing you-should-use plugin..."
if ! doesDirExist "$zshCustomDir/plugins/you-should-use"; then
	runOrFail "Could not clone you-should-use." git clone git@github.com:MichaelAquilina/zsh-you-should-use.git "$zshCustomDir/plugins/you-should-use"
	success "you-should-use installed"
else
	alreadyDone "you-should-use plugin is installed"
fi
