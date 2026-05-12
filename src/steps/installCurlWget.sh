#!/usr/bin/env bash

echo "Installing curl and wget..."
if ! isProgramInstalled curl || ! isProgramInstalled wget; then
	runOrFail "Could not install curl and wget." sudo dnf install wget curl -y
	success "curl and wget installed"
else
	alreadyDone "curl and wget are installed"
fi
