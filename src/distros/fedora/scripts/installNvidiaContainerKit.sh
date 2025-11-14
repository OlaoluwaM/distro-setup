#!/usr/bin/env bash

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

echo "Installing Nvidia container toolkit..."

if ! isProgramInstalled curl || ! isProgramInstalled docker; then
	echo "You need to install BOTH curl and docker before setting up and install the nvidia-container-toolkit."
	echo "Please do so, then re-run this script. Exiting..."
	exit 1
fi

if isPackageInstalled nvidia-container-toolkit && isProgramInstalled nvidia-ctk && isProgramInstalled nvidia-smi; then
	echo "Nvidia container toolkit has already been installed and setup. Skipping..."
	return
fi

echo "Configuring the production repository..."
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo |
	sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo >/dev/null
echo -e "Done!\n"

echo "Installing nvidia-container-toolkit package..."
# sudo dnf install -y nvidia-container-toolkit
NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.0-1
sudo dnf install -y \
	nvidia-container-toolkit \
	nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
echo -e "Done!\n"

echo "Configuring docker to use the nvidia-container-toolkit..."
if sudo nvidia-ctk runtime configure --runtime=docker; then
	echo -e "Done!\n"
else
	echo "There was an error configuring the nvidia-container-toolkit runtime for docker. Please check the output above for more information. Perhaps we don't yet have nvidia drivers setup yet?"
	# Per the prerequisites section of the install guide https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#prerequisites
	echo "Exiting..."
	exit 1
fi

echo "Restarting docker service..."
sudo systemctl restart docker
echo "Done!"
