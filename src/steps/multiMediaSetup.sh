#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work.
# You probably want the ffmpeg from RPM Fusion and not the one from the Fedora repos.

# https://rpmfusion.org/Configuration
echo "Installing RPMFusion free and non-free repos..."
runOrFail "Could not install the RPM Fusion free repository package." sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
runOrFail "Could not install the RPM Fusion nonfree repository package." sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
success "RPM Fusion repositories are installed"
echo -e "\n"

if isPackageInstalled ffmpeg; then
	alreadyDone "ffmpeg is installed"
else
	echo "Replacing ffmpeg-free with ffmpeg..."
	runOrFail "Could not update packages before swapping ffmpeg." sudo dnf update -y
	runOrFail "Could not swap ffmpeg-free for ffmpeg." sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

	runOrFail "Could not install ffmpeg-devel." sudo dnf install -y ffmpeg-devel

	echo "ffmpeg version: $(ffmpeg -version)"
	success "FFmpeg installed"
	echo -e "\n"
fi

# https://rpmfusion.org/Howto/Multimedia
echo "Installing hardware accelerated codecs..."
hardwareCodecPackages=()

function installMesaFreeworldDriver() {
	local fedoraPackage="$1"
	local freeworldPackage="$2"

	if isPackageInstalled "$freeworldPackage"; then
		alreadyDone "$freeworldPackage is installed"
		return
	fi

	if ! dnf -q list --available "$freeworldPackage" &>/dev/null; then
		skipStep "$freeworldPackage is not available in the enabled DNF repositories."
		return
	fi

	if isPackageInstalled "$fedoraPackage"; then
		runOrFail "Could not swap $fedoraPackage for $freeworldPackage." sudo dnf swap -y "$fedoraPackage" "$freeworldPackage" --allowerasing
	else
		runOrFail "Could not install $freeworldPackage." sudo dnf install -y "$freeworldPackage" --allowerasing
	fi
}

if hasIntelGpu; then
	echo "Detected Intel GPU. Queuing Intel media driver..."
	hardwareCodecPackages+=(intel-media-driver)
fi

if hasNvidiaGpu; then
	echo "Detected NVIDIA GPU. Queuing NVIDIA VA-API driver..."
	hardwareCodecPackages+=(libva-nvidia-driver)
fi

if hasAmdGpu; then
	echo "Detected AMD GPU. Installing AMD freeworld Mesa media drivers..."
	installMesaFreeworldDriver mesa-va-drivers mesa-va-drivers-freeworld
	installMesaFreeworldDriver mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
fi

if [[ ${#hardwareCodecPackages[@]} -gt 0 ]]; then
	runOrFail "Could not install hardware accelerated codec packages." sudo dnf install -y "${hardwareCodecPackages[@]}"
	success "Hardware accelerated codecs installed"
	echo -e "\n"
else
	skipStep "No supported GPU vendor detected for additional hardware codec packages."
	echo -e "\n"
fi

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
echo "Installing plugins for multimedia..."
runOrFail "Could not install multimedia plugin group." sudo dnf group install -y multimedia
success "Multimedia plugins installed"
echo -e "\n"

# https://rpmfusion.org/Howto/Multimedia
# Only attempt these steps if issues still arise despite the above installations
# echo "Installing additional codecs..."
# sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# echo "Done! Additional codecs have been installed"
