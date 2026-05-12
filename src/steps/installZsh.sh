#!/usr/bin/env bash

echo "Installing Zsh..."
if ! isProgramInstalled zsh; then
	sudo dnf install zsh util-linux-user -y
	echo "Zsh has been installed"
else
	echo "Zsh has already been installed"
fi
