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
	local fedoraVersion

	fedoraVersion="$(rpm -E %fedora)"

	# DNF installs are intentionally rerun; they are idempotent and keep reruns simple.
	runOrFail "Could not install the RPM Fusion free repository package." sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedoraVersion}.noarch.rpm"
	runOrFail "Could not install the RPM Fusion nonfree repository package." sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedoraVersion}.noarch.rpm"
	success "RPM Fusion repositories are installed"
}

function nvidiaDriverPackagesInstalled() {
	isPackageInstalled akmod-nvidia && isPackageInstalled xorg-x11-drv-nvidia
}

function failIfLikelyUnsupportedNvidiaGpu() {
	local nvidiaDevices

	if ! isProgramInstalled lspci; then
		return
	fi

	nvidiaDevices="$(lspci -Dnn | grep -Ei '(vga|3d|display).*nvidia|nvidia.*(vga|3d|display)' || true)"

	if grep -Eiq 'GeForce (GTX|GT) [456][0-9]{2}|GeForce GTX 7[678][0-9]|GeForce GT 7[123][0-9]|Quadro K|Tesla K|GRID K' <<<"$nvidiaDevices"; then
		echo "$nvidiaDevices"
		failSetup "Detected an older NVIDIA GPU that is likely unsupported by Fedora 44's current RPM Fusion akmod-nvidia driver. Install the appropriate RPM Fusion legacy driver manually instead."
	fi
}

function disableNouveau() {
	echo "Disabling nouveau and enabling NVIDIA DRM modesetting..."

	if ! printf '%s\n' \
		"blacklist nouveau" \
		"blacklist nova_core" \
		"options nouveau modeset=0" |
		sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null; then
		failSetup "Could not write nouveau blacklist file."
	fi

	runOrFail "Could not remove conflicting NVIDIA boot arguments." sudo grubby --update-kernel=ALL --remove-args="nomodeset rd.driver.blacklist=nouveau rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau modprobe.blacklist=nouveau,nova_core nvidia-drm.modeset=0 nvidia-drm.modeset=1"
	runOrFail "Could not add NVIDIA boot arguments." sudo grubby --update-kernel=ALL --args="rd.driver.blacklist=nouveau,nova_core modprobe.blacklist=nouveau,nova_core nvidia-drm.modeset=1"
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
echo -e "\n"

echo "Refreshing packages before installing NVIDIA drivers..."
runOrFail "Could not update packages before installing NVIDIA drivers." sudo dnf update --refresh -y
echo -e "\n"

runOrFail "Could not install NVIDIA driver prerequisites." sudo dnf install -y grubby kmodtool akmods openssl pciutils

if ! nvidiaDriverPackagesInstalled; then
	failIfLikelyUnsupportedNvidiaGpu
fi

disableNouveau

if nvidiaDriverPackagesInstalled; then
	enableNvidiaPowerServices
	alreadyDone "NVIDIA proprietary drivers are installed"
	return
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
