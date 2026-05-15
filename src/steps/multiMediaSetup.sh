#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work.
# You probably want the ffmpeg from RPM Fusion and not the one from the Fedora repos.

# https://rpmfusion.org/Configuration
echo "Installing RPMFusion free and non-free repos..."

function installRpmFusionReposIfMissing() {
	local fedoraVersion

	fedoraVersion="$(rpm -E %fedora)"

	# DNF installs are intentionally rerun; they are idempotent and keep reruns simple.
	runOrFail "Could not install the RPM Fusion free repository package." sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedoraVersion}.noarch.rpm"
	runOrFail "Could not install the RPM Fusion nonfree repository package." sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedoraVersion}.noarch.rpm"
	success "RPM Fusion repositories are installed"
}

function isDnfRepoEnabled() {
	local repoId="$1"

	dnf repolist --enabled | awk '{print $1}' | grep -Fx "$repoId" &>/dev/null
}

installRpmFusionReposIfMissing
echo -e "\n"

echo "Enabling Fedora OpenH264 repo..."
if isDnfRepoEnabled fedora-cisco-openh264; then
	alreadyDone "fedora-cisco-openh264 repository is enabled"
else
	runOrWarn "Could not enable fedora-cisco-openh264 repository." sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
fi
echo -e "\n"

if isPackageInstalled ffmpeg; then
	alreadyDone "ffmpeg is installed"
else
	runOrFail "Could not update packages before swapping ffmpeg." sudo dnf update -y
fi

if isPackageInstalled ffmpeg-free; then
	echo "Replacing ffmpeg-free with ffmpeg..."
	runOrFail "Could not swap ffmpeg-free for ffmpeg." sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
else
	echo "Installing ffmpeg..."
	runOrFail "Could not install ffmpeg." sudo dnf install -y ffmpeg --allowerasing
fi

echo "ffmpeg version: $(ffmpeg -version)"
success "FFmpeg installed"
echo -e "\n"

echo "Installing multimedia codec libraries..."
# DNF installs are intentionally rerun; they are idempotent and keep reruns simple.
runOrFail "Could not install multimedia codec libraries." sudo dnf install -y libavcodec-freeworld gstreamer1-plugin-openh264 mozilla-openh264
success "Multimedia codec libraries installed"
echo -e "\n"

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
echo "Installing plugins for multimedia..."
runOrFail "Could not install multimedia plugin group." sudo dnf group install -y multimedia
runOrFail "Could not update multimedia plugin group with RPM Fusion packages." sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin --allowerasing
success "Multimedia plugins installed and updated"
echo -e "\n"

# https://rpmfusion.org/Howto/Multimedia
echo "Installing hardware accelerated codecs..."
hardwareCodecPackages=()
detectedHardwareCodecGpu=false

function installMesaFreeworldDriver() {
	local fedoraPackage="$1"
	local freeworldPackage="$2"

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
	detectedHardwareCodecGpu=true
	echo "Detected Intel GPU. Queuing Intel media driver..."
	hardwareCodecPackages+=(intel-media-driver)
fi

if hasNvidiaGpu; then
	detectedHardwareCodecGpu=true
	echo "Detected NVIDIA GPU. Queuing NVIDIA VA-API driver..."
	hardwareCodecPackages+=(libva-nvidia-driver)

	if isProgramInstalled nvidia-smi || rpm -qa 'xorg-x11-drv-nvidia*' | grep -q '^xorg-x11-drv-nvidia'; then
		echo "Detected NVIDIA proprietary driver. Queuing NVIDIA CUDA/NVDEC/NVENC support..."
		hardwareCodecPackages+=(xorg-x11-drv-nvidia-cuda)
	else
		warn "NVIDIA GPU detected, but the proprietary NVIDIA driver is not installed. NVDEC/NVENC support requires the RPM Fusion NVIDIA driver stack."
	fi
fi

# AMD codecs replace Fedora's Mesa VA driver with RPM Fusion's freeworld build,
# so this uses swap/install logic instead of the plain queued install pattern above.
if hasAmdGpu; then
	detectedHardwareCodecGpu=true
	echo "Detected AMD GPU. Installing AMD freeworld Mesa media drivers..."
	installMesaFreeworldDriver mesa-va-drivers mesa-va-drivers-freeworld
fi

if [[ ${#hardwareCodecPackages[@]} -gt 0 ]]; then
	runOrFail "Could not install hardware accelerated codec packages." sudo dnf install -y "${hardwareCodecPackages[@]}"
	success "Hardware accelerated codecs installed"
	echo -e "\n"
else
	if [[ $detectedHardwareCodecGpu == true ]]; then
		alreadyDone "No queued hardware codec packages needed installation"
	else
		skipStep "No supported GPU vendor detected for additional hardware codec packages."
	fi
	echo -e "\n"
fi

# https://rpmfusion.org/Howto/Multimedia
# Only attempt these steps if issues still arise despite the above installations
# echo "Installing additional codecs..."
# sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# echo "Done! Additional codecs have been installed"
