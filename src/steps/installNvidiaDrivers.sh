#!/usr/bin/env bash

# Install NVIDIA's proprietary driver from RPM Fusion.
# https://rpmfusion.org/Howto/NVIDIA
# This script will also disable the nouveau driver and enable NVIDIA's DRM modesetting, which is required for Wayland sessions and NVIDIA power-management services to work properly.
# https://asus-linux.org/guides/fedora-guide/#install-nvidia-graphics-drivers-amd-gpu-can-skip

echo "Installing NVIDIA proprietary drivers..."

if ! hasNvidiaGpu; then
	skipStep "No NVIDIA GPU detected."
	return
fi

function installRpmFusionRepos() {
	runOrFail "Could not install the RPM Fusion free repository package." sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
	runOrFail "Could not install the RPM Fusion nonfree repository package." sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}

function isSecureBootEnabled() {
	isProgramInstalled mokutil && mokutil --sb-state 2>/dev/null | grep -qi "SecureBoot enabled"
}

function isAkmodsKeyEnrolled() {
	local publicKey="/etc/pki/akmods/certs/public_key.der"

	doesFileExist "$publicKey" && mokutil --test-key "$publicKey" &>/dev/null
}

function disableNouveau() {
	echo "Disabling nouveau and enabling NVIDIA DRM modesetting..."

	if ! printf '%s\n' \
		"blacklist nouveau" \
		"options nouveau modeset=0" |
		sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null; then
		failSetup "Could not write nouveau blacklist file."
	fi

	runOrFail "Could not remove conflicting NVIDIA boot arguments." sudo grubby --update-kernel=ALL --remove-args="nomodeset rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=0 nvidia-drm.modeset=1"
	runOrFail "Could not add NVIDIA boot arguments." sudo grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1"
	success "nouveau is disabled for current and future kernel entries"
	echo -e "\n"
}

function enableNvidiaPowerServices() {
	echo "Enabling NVIDIA power-management services..."
	runOrWarn "Could not enable one or more NVIDIA power-management services." sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service
	echo -e "\n"
}

echo "Installing RPM Fusion repositories..."
installRpmFusionRepos
success "RPM Fusion repositories are installed"
echo -e "\n"

echo "Refreshing packages before installing NVIDIA drivers..."
runOrFail "Could not update packages before installing NVIDIA drivers." sudo dnf update --refresh -y
echo -e "\n"

runOrFail "Could not install NVIDIA driver prerequisites." sudo dnf install -y grubby kmodtool akmods mokutil openssl

disableNouveau

if isPackageInstalled akmod-nvidia && isPackageInstalled xorg-x11-drv-nvidia-cuda; then
	enableNvidiaPowerServices
	alreadyDone "NVIDIA proprietary drivers are installed"
	return
fi

if isSecureBootEnabled && ! isAkmodsKeyEnrolled; then
	echo "Secure Boot is enabled. Creating and importing an akmods signing key..."
	runOrFail "Could not generate akmods signing key." sudo kmodgenca -a
	runOrFail "Could not import akmods signing key into MOK." sudo mokutil --import /etc/pki/akmods/certs/public_key.der
	pauseForRerun "Enroll the akmods key in the MOK manager during reboot, then re-run setup to install the NVIDIA driver."
fi

echo "Installing NVIDIA driver packages..."
runOrFail "Could not install NVIDIA proprietary driver packages." sudo dnf install -y \
	kernel-devel \
	kernel-headers \
	akmod-nvidia \
	xorg-x11-drv-nvidia-cuda
success "NVIDIA driver packages installed"
echo -e "\n"

enableNvidiaPowerServices

echo "Building NVIDIA kernel module for the current kernel..."
runOrFail "Could not build NVIDIA kernel module." sudo akmods --force
runOrWarn "Could not regenerate initramfs after NVIDIA driver installation." sudo dracut --force

if modinfo nvidia &>/dev/null; then
	success "NVIDIA kernel module is built"
else
	warn "NVIDIA kernel module is not visible yet. akmods may still be finishing in the background."
fi

pauseForRerun "NVIDIA drivers are installed. Reboot before continuing so the proprietary driver can load."
