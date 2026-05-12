#!/usr/bin/env bash

echo "Installing Zsh..."
if ! isProgramInstalled zsh; then
	runOrFail "Could not install Zsh." sudo dnf install zsh util-linux-user -y
	success "Zsh installed"
else
	alreadyDone "Zsh is installed"
fi
