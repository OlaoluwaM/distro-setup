#!/usr/bin/env bash

echo "Installing VS Code from RPM repository..."
if ! isProgramInstalled code; then
	sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

	dnf check-update
	sudo dnf install -y code
	echo "VS Code has been installed"
else
	echo "VS Code has already been installed"
fi
