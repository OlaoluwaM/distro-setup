#!/usr/bin/env bash

echo "Installing Git..."
if ! isProgramInstalled git; then
	sudo dnf install git-all -y
	echo "Git has been installed"
else
	echo "Git has already been installed"
fi
