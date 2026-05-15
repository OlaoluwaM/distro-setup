#!/usr/bin/env bash

# Setup Flathub and install certain flatpaks
# https://developer.fedoraproject.org/deployment/flatpak/flatpak-usage.html

echo "Updating installed packages..."
runOrFail "Could not update installed packages before setting up Flathub." sudo dnf update -y
success "Installed packages updated"
echo -e "\n"

echo "Adding flathub repository if it hasn't been added already..."

if ! isProgramInstalled flatpak; then
	echo "Looks like Flathub hasn't been integrated yet :/"
	skipStep "Please install Flatpak support, then re-run this script."
	return
else
	runOrFail "Could not add the Flathub remote." flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	success "Flathub remote is configured"
	runOrFail "Could not allow Flatpak apps to read $HOME/.themes." sudo flatpak override --filesystem="$HOME/.themes"
	runOrFail "Could not allow Flatpak apps to read $HOME/.icons." sudo flatpak override --filesystem="$HOME/.icons"
	success "Flatpak filesystem overrides are configured"
fi
echo -e "\n"

echo "Installing flatpaks..."
flatpakList="$SETUP_ASSETS_DIR/flatpaks.txt"

if ! doesFileExist "$flatpakList"; then
	echo "Cannot find flatpak app list at $flatpakList"
	return
fi

failedInstallCount=0

while IFS= read -r applicationId; do
	[[ -z "$applicationId" || "$applicationId" == \#* ]] && continue

	# Flatpak installs are intentionally rerun; they are idempotent and keep reruns simple.
	if flatpak install flathub "$applicationId" -y; then
		success "$applicationId installed"
	else
		warn "Failed to install $applicationId"
		((failedInstallCount++))
	fi

	echo -e "\n"
done <"$flatpakList"

if [[ $failedInstallCount -gt 0 ]]; then
	failSetup "$failedInstallCount Flatpak install(s) failed."
fi

success "Flatpak apps are installed"
