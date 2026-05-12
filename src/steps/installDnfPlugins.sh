#!/usr/bin/env bash

echo "Installing DNF plugins..."
if ! isPackageInstalled dnf5-plugins; then
	sudo dnf install dnf5-plugins -y
	echo "dnf5-plugins has been installed"
else
	echo "dnf5-plugins has already been installed"
fi
