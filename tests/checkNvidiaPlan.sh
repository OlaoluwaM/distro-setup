#!/usr/bin/env bash

# Dry-run diagnostic for the NVIDIA driver setup. This script prints what the
# NVIDIA setup would try to do without changing packages, boot args, services,
# initramfs, or modprobe configuration.

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/lib/core.sh
. "$scriptDir/../src/lib/core.sh"

function printPackageState() {
	local packageName="$1"

	if isPackageInstalled "$packageName"; then
		printf '  installed: %s\n' "$packageName"
	elif dnf -q list --available "$packageName" &>/dev/null; then
		printf '  available: %s\n' "$packageName"
	else
		printf '  unavailable in enabled repos: %s\n' "$packageName"
	fi
}

function printDetectorState() {
	local label="$1"
	local detector="$2"

	if "$detector"; then
		printf '  %s: yes\n' "$label"
	else
		printf '  %s: no\n' "$label"
	fi
}

function printDisplayDevices() {
	if isProgramInstalled lspci; then
		lspci -nn | grep -Ei 'vga|3d|display|nvidia|intel|amd' || true
	else
		echo "lspci is not installed."
	fi
}

function printLikelySupportState() {
	local nvidiaDevices

	if ! isProgramInstalled lspci; then
		echo "  unknown: lspci is not installed."
		return
	fi

	nvidiaDevices="$(lspci -Dnn | grep -Ei '(vga|3d|display).*nvidia|nvidia.*(vga|3d|display)' || true)"

	if [[ -z "$nvidiaDevices" ]]; then
		echo "  no NVIDIA display devices found by lspci."
	elif grep -Eiq 'GeForce (GTX|GT) [456][0-9]{2}|GeForce GTX 7[678][0-9]|GeForce GT 7[123][0-9]|Quadro K|Tesla K|GRID K' <<<"$nvidiaDevices"; then
		echo "  warning: detected an older NVIDIA GPU that is likely unsupported by Fedora 44's current RPM Fusion akmod-nvidia driver."
		printf '%s\n' "$nvidiaDevices" | sed 's/^/    /'
	else
		echo "  no obvious legacy NVIDIA GPU pattern detected."
		printf '%s\n' "$nvidiaDevices" | sed 's/^/    /'
	fi
}

function printBootArgsState() {
	if isProgramInstalled grubby; then
		grubby --info=ALL | grep -E '^(kernel|args)=' || true
	else
		echo "  grubby is not installed."
	fi
}

function printNvidiaServiceState() {
	if isProgramInstalled systemctl; then
		systemctl list-unit-files 'nvidia-*' --no-pager || true
	else
		echo "  systemctl is not installed."
	fi
}

echo "NVIDIA driver setup dry run"
echo "No packages will be installed and no system settings will be changed."
echo -e "\nDetected display-related PCI devices:"
printDisplayDevices

echo -e "\nGPU detector results:"
printDetectorState NVIDIA hasNvidiaGpu

echo -e "\nLikely RPM Fusion driver support:"
printLikelySupportState

echo -e "\nNVIDIA package state:"
printPackageState grubby
printPackageState kmodtool
printPackageState akmods
printPackageState openssl
printPackageState pciutils
printPackageState kernel-devel
printPackageState kernel-headers
printPackageState akmod-nvidia
printPackageState xorg-x11-drv-nvidia
printPackageState xorg-x11-drv-nvidia-cuda

echo -e "\nCurrent NVIDIA-related boot args:"
printBootArgsState

echo -e "\nNVIDIA service unit state:"
printNvidiaServiceState

echo -e "\nCommands the real NVIDIA step may run:"
echo "  sudo dnf install RPM Fusion release packages"
echo "  sudo dnf update --refresh -y"
echo "  sudo dnf install -y grubby kmodtool akmods openssl pciutils"
echo "  sudo tee /etc/modprobe.d/blacklist-nouveau.conf"
echo "  sudo grubby --update-kernel=ALL --remove-args=\"nomodeset rd.driver.blacklist=nouveau rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau modprobe.blacklist=nouveau,nova_core nvidia-drm.modeset=0 nvidia-drm.modeset=1\""
echo "  sudo grubby --update-kernel=ALL --args=\"rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau,nova_core nvidia-drm.modeset=1\""
echo "  sudo dnf install -y kernel-devel kernel-headers akmod-nvidia xorg-x11-drv-nvidia-cuda"
echo "  sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service"
echo "  sudo akmods --force"
echo "  sudo dracut --force"
