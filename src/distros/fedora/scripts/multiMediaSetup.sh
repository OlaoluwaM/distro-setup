#!/usr/bin/env bash

# Installing ffmpeg for Firefox videos to work
# You probably want the ffmpeg from rpmfusion and not the one from the fedora repos: https://www.reddit.com/r/Fedora/comments/tfgf3s/ffmpeg_coming_to_fedora/

if isProgramInstalled ffmpeg; then
  echo "Seems like ffmpeg has already been installed. Skipping..."
  return
fi

# https://rpmfusion.org/Howto/Multimedia
echo "Installing ffmpeg to avoid firefox video playback corruption..."
sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

sudo dnf update -y
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

echo "ffmpeg version: $(ffmpeg -version)"
echo -e "Done! FFmpeg has been installed\n"

# https://rpmfusion.org/Howto/Multimedia
echo "Installing hardware accelerated codecs..."
sudo dnf install intel-media-driver libva-nvidia-driver -y
echo -e "Done! Hardware accelerated codecs have been installed\n"

# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
echo "Installing plugins for multimedia..."
sudo dnf group install multimedia -y
echo -e "Done! Multimedia plugins have been installed\n"

# https://rpmfusion.org/Howto/Multimedia
echo "Installing additional codecs..."
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
echo "Done! Additional codecs have been installed"
