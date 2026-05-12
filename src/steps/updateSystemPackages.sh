#!/usr/bin/env bash

refreshArg="${1:-}"

echo "Updating installed packages..."
if [[ "$refreshArg" == "--refresh" ]]; then
	runOrFail "Could not update installed packages with refreshed metadata." sudo dnf update --refresh -y
else
	runOrFail "Could not update installed packages." sudo dnf update -y
fi
success "Installed packages updated"
