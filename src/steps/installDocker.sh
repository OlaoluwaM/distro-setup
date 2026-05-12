#!/usr/bin/env bash

# Install docker
# https://docs.docker.com/engine/install/fedora/

echo "Installing Docker..."

function dockerWorksForCurrentUser() {
	docker run hello-world &>/dev/null
}

function dockerWorksWithSudo() {
	sudo docker run hello-world &>/dev/null
}

function ensureDockerGroupMembership() {
	echo "Creating docker group..."
	if ! getent group docker &>/dev/null; then
		runOrFail "Could not create docker group." sudo groupadd docker
	fi

	if ! id -nG "$USER" | grep -qw docker; then
		runOrFail "Could not add $USER to the docker group." sudo usermod -aG docker "$USER"
		success "$USER added to the docker group"
	else
		alreadyDone "$USER is in the docker group"
	fi

	echo "Please perform any required restarts or re-login before re-running this script"
	echo "Because of the tendency to forget to re-login this script will continue to exit until you do so."
	pauseForRerun "Docker group membership changed or needs a fresh login session."
}

if dockerWorksForCurrentUser; then
	alreadyDone "Docker is installed and works for the current user"
	return
fi

if isProgramInstalled docker; then
	runOrFail "Could not enable and start Docker." sudo systemctl enable --now docker

	if dockerWorksForCurrentUser; then
		alreadyDone "Docker is installed and works for the current user"
		return
	fi

	if dockerWorksWithSudo; then
		echo "Docker works with sudo, but not as the current user."
		echo "Maybe try logging out and back in, or restarting."
		echo "If that doesn't work, refer to these steps: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user"
		ensureDockerGroupMembership
	fi

	failSetup "Docker is installed, but the hello-world verification failed."
fi

echo "Purging old docker artifacts if they exist..."
runOrFail "Could not purge old Docker artifacts." sudo dnf -y remove docker \
	docker-client \
	docker-client-latest \
	docker-common \
	docker-latest \
	docker-latest-logrotate \
	docker-logrotate \
	docker-selinux \
	docker-engine-selinux \
	docker-engine
success "Old Docker artifacts purged"
echo -e "\n"

echo "Setting up Docker repository..."
runOrFail "Could not install dnf-plugins-core for Docker repository setup." sudo dnf -y install dnf-plugins-core
runOrFail "Could not add the Docker repository." sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
success "Docker repository configured"
echo -e "\n"

echo "Installing Docker Engine..."
echo "GPG fingerprint should match: '060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35'"
runOrFail "Could not install Docker Engine." sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
success "Docker Engine installed"
echo -e "\n"

echo "Starting up Docker service..."
runOrFail "Could not enable and start Docker." sudo systemctl enable --now docker
success "Docker service is enabled and running"
echo -e "\n"

echo "Testing Docker installation..."
if dockerWorksWithSudo; then
	success "Docker installation verified with sudo"
else
	failSetup "Docker installation failed"
fi
echo -e "\n"

echo "Configuring the containerd service to run on boot..."
runOrFail "Could not enable containerd.service." sudo systemctl enable containerd.service
success "containerd.service enabled"
echo -e "\n"

echo "Updating installed packages..."
runOrFail "Could not update installed packages after installing Docker." sudo dnf update -y
success "Installed packages updated"
echo -e "\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
# https://docs.docker.com/engine/install/linux-postinstall/
ensureDockerGroupMembership
