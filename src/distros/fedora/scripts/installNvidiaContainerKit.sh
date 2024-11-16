#!/usr/bin/env bash

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

echo "Installing Nvidia container toolkit..."

if ! isProgramInstalled curl || ! isProgramInstalled docker; then
  echo "You need to install BOTH curl and docker before setting up and install the nvidia-container-toolkit."
  echo "Please do so, then re-run this script. Exiting..."
  exit 1
fi

echo "Configuring the production repository..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo |
  sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
echo -e "Done!\n"

echo "Installing nvidia-container-toolkit package..."
sudo dnf install -y nvidia-container-toolkit
echo -e "Done!\n"

echo "Configuring docker to use the nvidia-container-toolkit..."
sudo nvidia-ctk runtime configure --runtime=docker
echo -e "Done!\n"

echo "Restarting docker service..."
sudo systemctl restart docker
echo "Done!"
