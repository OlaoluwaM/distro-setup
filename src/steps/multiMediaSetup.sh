#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work.
# You probably want the ffmpeg from RPM Fusion and not the one from the Fedora repos.

# https://rpmfusion.org/Configuration
echo "Installing RPMFusion free and non-free repos..."
sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
echo -e "Done\n"

if isPackageInstalled ffmpeg; then
	echo "Seems like ffmpeg has already been installed. Skipping ffmpeg swap..."
else
	echo "Replacing ffmpeg-free with ffmpeg..."
	sudo dnf update -y
	sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

	sudo dnf install -y ffmpeg-devel

	echo "ffmpeg version: $(ffmpeg -version)"
	echo -e "Done! FFmpeg has been installed\n"
fi

# https://rpmfusion.org/Howto/Multimedia
echo "Installing hardware accelerated codecs..."
hardwareCodecPackages=()

if hasIntelGpu; then
	echo "Detected Intel GPU. Queuing Intel media driver..."
	hardwareCodecPackages+=(intel-media-driver)
fi

if hasNvidiaGpu; then
	echo "Detected NVIDIA GPU. Queuing NVIDIA VA-API driver..."
	hardwareCodecPackages+=(libva-nvidia-driver)
fi

if hasAmdGpu; then
	echo "Detected AMD GPU. Queuing AMD freeworld Mesa media drivers..."
	hardwareCodecPackages+=(mesa-va-drivers-freeworld mesa-vdpau-drivers-freeworld)
fi

if [[ ${#hardwareCodecPackages[@]} -gt 0 ]]; then
	sudo dnf install -y "${hardwareCodecPackages[@]}"
	echo -e "Done! Hardware accelerated codecs have been installed\n"
else
	echo -e "No supported GPU vendor detected for additional hardware codec packages. Skipping...\n"
fi

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
echo "Installing plugins for multimedia..."
sudo dnf group install -y multimedia
echo -e "Done! Multimedia plugins have been installed\n"

# https://rpmfusion.org/Howto/Multimedia
# Only attempt these steps if issues still arise despite the above installations
# echo "Installing additional codecs..."
# sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# echo "Done! Additional codecs have been installed"
