#!/usr/bin/env bash

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

echo "Installing Nvidia container toolkit..."

if ! hasNvidiaGpu; then
	skipStep "No NVIDIA GPU detected."
	return
fi

if ! isProgramInstalled curl || ! isProgramInstalled docker; then
	echo "You need to install BOTH curl and docker before setting up and install the nvidia-container-toolkit."
	skipStep "Please do so, then re-run this script."
	return
fi

if ! isProgramInstalled nvidia-smi; then
	skipStep "NVIDIA proprietary drivers are not loaded yet. Install/reboot into the NVIDIA driver first, then re-run this script."
	return
fi

if isPackageInstalled nvidia-container-toolkit && isProgramInstalled nvidia-ctk && isProgramInstalled nvidia-smi; then
	alreadyDone "Nvidia container toolkit is installed and set up"
	return
fi

echo "Configuring the production repository..."
if ! curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo |
	sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo >/dev/null; then
	failSetup "Could not configure the Nvidia container toolkit repository."
fi
success "Nvidia container toolkit repository configured"
echo -e "\n"

echo "Installing nvidia-container-toolkit package..."
# sudo dnf install -y nvidia-container-toolkit
NVIDIA_CONTAINER_TOOLKIT_VERSION=1.19.0-1
runOrFail "Could not install nvidia-container-toolkit packages." sudo dnf install -y \
	nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
	libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
success "nvidia-container-toolkit packages installed"
echo -e "\n"

echo "Configuring docker to use the nvidia-container-toolkit..."
if sudo nvidia-ctk runtime configure --runtime=docker; then
	success "Docker configured to use nvidia-container-toolkit"
	echo -e "\n"
else
	echo "There was an error configuring the nvidia-container-toolkit runtime for docker. Please check the output above for more information. Perhaps we don't yet have nvidia drivers setup yet?"
	# Per the prerequisites section of the install guide https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#prerequisites
	failSetup "Could not configure the nvidia-container-toolkit runtime for Docker."
fi

echo "Restarting docker service..."
runOrFail "Could not restart Docker after configuring Nvidia container toolkit." sudo systemctl restart docker
success "Docker restarted"
