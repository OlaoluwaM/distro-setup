#!/usr/bin/env bash

echo "Installing curl and wget..."
if ! isProgramInstalled curl || ! isProgramInstalled wget; then
	sudo dnf install wget curl -y
	echo "curl and wget have been installed"
else
	echo "curl and wget have already been installed"
fi
