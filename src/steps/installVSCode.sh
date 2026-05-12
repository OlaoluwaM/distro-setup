#!/usr/bin/env bash

echo "Installing VS Code from RPM repository..."
if ! isProgramInstalled code; then
	runOrFail "Could not import the Microsoft RPM signing key." sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
	if ! echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null; then
		failSetup "Could not write /etc/yum.repos.d/vscode.repo."
	fi

	dnf check-update
	checkUpdateStatus=$?
	if [[ $checkUpdateStatus -ne 0 && $checkUpdateStatus -ne 100 ]]; then
		failSetup "Could not refresh DNF metadata for VS Code."
	fi

	runOrFail "Could not install VS Code." sudo dnf install -y code
	success "VS Code installed"
else
	alreadyDone "VS Code is installed"
fi
