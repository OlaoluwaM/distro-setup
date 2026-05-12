#!/usr/bin/env bash

echo "Installing Git..."
if ! isProgramInstalled git; then
	runOrFail "Could not install Git." sudo dnf install git-all -y
	success "Git installed"
else
	alreadyDone "Git is installed"
fi
