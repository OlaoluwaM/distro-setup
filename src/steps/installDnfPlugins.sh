#!/usr/bin/env bash

echo "Installing DNF plugins..."
if ! isPackageInstalled dnf5-plugins; then
	runOrFail "Could not install dnf5-plugins." sudo dnf install dnf5-plugins -y
	success "dnf5-plugins installed"
else
	alreadyDone "dnf5-plugins is installed"
fi
