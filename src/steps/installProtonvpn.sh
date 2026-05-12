#!/usr/bin/env bash

# Setup ProtonVPN
# Requirements:
# Depends on: Package installation step

# Checkout the following for installation steps
# https://protonvpn.com/support/linux-cli/ (for the cli)
# https://protonvpn.com/support/official-linux-vpn-fedora/ (for the gui)

echo "Installing protonvpn..."

protonReleaseVersion="1.0.4-1"
fedoraVersion="$(rpm -E %fedora)"
protonRepoPackage="protonvpn-stable-release-${protonReleaseVersion}.noarch.rpm"
protonRepoUrl="https://repo.protonvpn.com/fedora-${fedoraVersion}-stable/protonvpn-stable-release/${protonRepoPackage}"
packagesToInstall=()

if isPackageInstalled proton-vpn-gnome-desktop && isPackageInstalled proton-vpn-cli; then
	alreadyDone "Proton VPN GUI and CLI are installed"
	return
fi

if ! isPackageInstalled protonvpn-stable-release; then
	runOrFail "Could not install the Proton VPN repository package." sudo dnf install -y "$protonRepoUrl"
	runOrFail "Could not refresh packages after installing the Proton VPN repository." sudo dnf update --refresh -y
	success "Proton VPN repository configured"
fi

if ! isPackageInstalled proton-vpn-gnome-desktop; then
	packagesToInstall+=(proton-vpn-gnome-desktop)
fi

if ! isPackageInstalled proton-vpn-cli; then
	packagesToInstall+=(proton-vpn-cli)
fi

if [[ ${#packagesToInstall[@]} -gt 0 ]]; then
	runOrFail "Could not install Proton VPN packages." sudo dnf install -y --refresh "${packagesToInstall[@]}"
	success "Proton VPN packages installed"
fi

echo "Note: Proton says the GUI and CLI can be installed together, but should not be run at the same time."
success "Proton VPN installation complete"
