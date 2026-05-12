#!/usr/bin/env bash

refreshArg="${1:-}"

echo "Updating installed packages..."
if [[ "$refreshArg" == "--refresh" ]]; then
	sudo dnf update --refresh -y
else
	sudo dnf update -y
fi
echo "Installed packages updated"
