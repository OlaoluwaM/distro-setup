#!/usr/bin/env bash

# Install Google Chrome

# https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/

if ! isProgramInstalled google-chrome; then
	echo "Installing Google Chrome..."
	runOrFail "Could not install fedora-workstation-repositories." sudo dnf install -y fedora-workstation-repositories
	runOrFail "Could not enable the Google Chrome repository." sudo dnf config-manager setopt google-chrome.enabled=1
	runOrFail "Could not install Google Chrome." sudo dnf install -y google-chrome-stable
	success "Google Chrome installed"
else
	alreadyDone "Google Chrome is installed"
fi
