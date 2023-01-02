#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work
# If these steps are not enough you can supplement them with the steps found here (https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/)

echo "Installing ffmpeg to avoid firefox video playback corruption..."
sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install ffmpeg --allowerasing -y

echo "ffmpeg version: $(ffmpeg -version)"
echo "Done! FFmpeg has been installed"
