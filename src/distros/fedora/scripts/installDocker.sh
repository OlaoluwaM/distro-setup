#!/usr/bin/env bash

# Install docker
# https://docs.docker.com/engine/install/fedora/

echo "Installing Docker..."

docker run hello-world &>/dev/null
DOCKER_TEST_CMD_EXIT_CODE="$?"

if [[ $DOCKER_TEST_CMD_EXIT_CODE -eq 0 ]]; then
  echo "Seems like docker has already been installed and configured. Skipping..."
  return
fi

sudo docker run hello-world &>/dev/null
ROOT_DOCKER_TEST_EXIT_CODE="$?"

if [[ $ROOT_DOCKER_TEST_EXIT_CODE -eq 0 ]]; then
  echo "Seems like docker has already been installed and configured, but not without sudo"
  echo "Maybe try logging out and back in, or restarting."
  echo "If that doesn't work, refer to these steps: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user"
  echo "Rerun this script after fixing this issue. Stopping here..."
  exit 0
fi

echo "Purging old docker artifacts if they exist..."
sudo dnf -y remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine
echo -e "Purge complete\n"

echo "Setting up Docker repository..."
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager add-repo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
echo -e "Repo setup complete\n"

echo "Installing Docker Engine..."
echo "GPG fingerprint should match: '060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35'"
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo -e "Installation complete\n"

echo "Starting up Docker service..."
sudo systemctl start docker
echo -e "Docker service is now up and running\n"

echo "Testing Docker installation..."
sudo docker run hello-world
DOCKER_TEST_EXIT_CODE="$?"

if [[ $DOCKER_TEST_EXIT_CODE -eq 0 ]]; then
  echo "Success! Docker installation complete"
else
  echo "Something went wrong! Docker installation failed"
  exit 1
fi
echo -e "\n"

echo "Configuring docker service to run on boot..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
echo -e "Configurations complete!\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
# https://docs.docker.com/engine/install/linux-postinstall/
echo "Creating docker group..."
if ! (getent group docker | grep "$USER") &>/dev/null; then
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  echo "Done! You may need to logout and then back in to see the changes"
  echo "If you are in a VM, you might need to restart the VM for the groups changes to take effect"
else
  echo "Seems like you have already been added to the docker group. Moving on..."
fi

echo "Please perform any required restarts or re-login before re-running this script"
echo "Because of the tendency to forget to re-login this script will continue to exit until you do so. Exiting..."
exit 0
