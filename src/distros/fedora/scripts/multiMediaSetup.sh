#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work
# You probably want the ffmpeg from rpmfusion and not the one from the fedora repos: https://www.reddit.com/r/Fedora/comments/tfgf3s/ffmpeg_coming_to_fedora/

if isPackageInstalled ffmpeg; then
  echo "Seems like ffmpeg has already been installed. Skipping..."
  return
fi

# https://rpmfusion.org/Configuration
echo "Installing RPMFusion free and non-free repos..."
sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
echo -e "Done\n"

echo "Replacing ffmpeg-free with ffmpeg..."
sudo dnf update -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

sudo dnf install -y ffmpeg-devel

echo "ffmpeg version: $(ffmpeg -version)"
echo -e "Done! FFmpeg has been installed\n"

# https://rpmfusion.org/Howto/Multimedia
echo "Installing hardware accelerated codecs..."
sudo dnf install intel-media-driver libva-nvidia-driver -y
echo -e "Done! Hardware accelerated codecs have been installed\n"

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
echo "Installing plugins for multimedia..."
sudo dnf group install -y multimedia
echo -e "Done! Multimedia plugins have been installed\n"

# https://rpmfusion.org/Howto/Multimedia
# Only attempt these steps if issues still arise despite the above installations
# echo "Installing additional codecs..."
# sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
# echo "Done! Additional codecs have been installed"
