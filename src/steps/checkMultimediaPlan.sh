#!/usr/bin/env bash

# Dry-run diagnostic for multimedia setup. This script prints what the multimedia
# setup would try to install without changing the system.

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/lib/core.sh
. "$scriptDir/../lib/core.sh"

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

echo "Multimedia setup dry run"
echo "No packages will be installed and no system settings will be changed."
echo -e "\nDetected display-related PCI devices:"
printDisplayDevices

echo -e "\nGPU detector results:"
printDetectorState Intel hasIntelGpu
printDetectorState NVIDIA hasNvidiaGpu
printDetectorState AMD hasAmdGpu

echo -e "\nBase multimedia package state:"
printPackageState ffmpeg
printPackageState ffmpeg-free
printPackageState libavcodec-freeworld
printPackageState gstreamer1-plugin-openh264
printPackageState mozilla-openh264

echo -e "\nHardware codec package plan:"
hardwareCodecPackages=()
detectedHardwareCodecGpu=false

if hasIntelGpu; then
	detectedHardwareCodecGpu=true
	hardwareCodecPackages+=(intel-media-driver)
fi

if hasNvidiaGpu; then
	detectedHardwareCodecGpu=true
	hardwareCodecPackages+=(libva-nvidia-driver)

	if isProgramInstalled nvidia-smi || rpm -qa 'xorg-x11-drv-nvidia*' | grep -q '^xorg-x11-drv-nvidia'; then
		hardwareCodecPackages+=(xorg-x11-drv-nvidia-cuda)
	else
		echo "  note: NVIDIA GPU detected, but proprietary NVIDIA driver stack was not detected."
	fi
fi

if hasAmdGpu; then
	detectedHardwareCodecGpu=true
	printPackageState mesa-va-drivers
	printPackageState mesa-va-drivers-freeworld
fi

if [[ ${#hardwareCodecPackages[@]} -gt 0 ]]; then
	for packageName in "${hardwareCodecPackages[@]}"; do
		printPackageState "$packageName"
	done
elif [[ $detectedHardwareCodecGpu == true ]]; then
	echo "  no queued generic hardware codec packages."
else
	echo "  no supported physical GPU detected."
fi

echo -e "\nCommands the real multimedia step may run:"
echo "  sudo dnf install RPM Fusion release packages"
echo "  sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1"
echo "  sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y OR sudo dnf install -y ffmpeg --allowerasing"
echo "  sudo dnf install -y libavcodec-freeworld gstreamer1-plugin-openh264 mozilla-openh264"
echo "  sudo dnf group install -y multimedia"

if [[ ${#hardwareCodecPackages[@]} -gt 0 ]]; then
	printf '  sudo dnf install -y'
	printf ' %s' "${hardwareCodecPackages[@]}"
	printf '\n'
fi

if hasAmdGpu; then
	echo "  sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld --allowerasing OR sudo dnf install -y mesa-va-drivers-freeworld --allowerasing"
fi
