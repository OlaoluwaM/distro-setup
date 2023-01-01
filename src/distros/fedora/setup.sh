#!/usr/bin/env bash

# shellcheck disable=SC2317

fedoraDistroSetupDir="$(dirname "$0")"
rootDir="$(dirname "$(dirname "$fedoraDistroSetupDir")")"
commonScriptsDir="$rootDir/common"

# To expose utilities for later use
# shellcheck source=../../common/_internals.sh
. "$commonScriptsDir/_internals.sh"

if ! doesFileExist "$fedoraDistroSetupDir/.env"; then
  echo "A .env file is required. Exiting..."
  exit 1
fi

sudo dnf update -y
echo -e "\n"

if ! isProgramInstalled zsh; then
  echo "Installing ZSH..."
  sudo dnf install zsh util-linux-user -y
  echo "Done!"
else
  echo "ZSH is already installed"
fi
echo -e "\n"

# shellcheck source=../../common/setupZsh.sh
. "$commonScriptsDir/setupZsh.sh"
echo -e "\n"

# Install Git
if ! isProgramInstalled git; then
  echo "Seems like you do not have git installed :/. Installing..."
  sudo dnf install git-all -y
  echo "Git successfully installed!"
else
  echo "Seems you already have git installed"
fi
echo -e "\n"

if ! isProgramInstalled curl && ! isProgramInstalled wget; then
  echo "Installing curl and wget..."
  sudo dnf install wget curl -y
  echo "Installed curl and wget"
else
  echo "curl and wget have been already been installed"
fi
echo -e "\n"

# shellcheck source=../../common/installOMZ.sh
. "$commonScriptsDir/installOMZ.sh"
echo -e "\n"

exposeEnvValues "$fedoraDistroSetupDir/.env"

if ! isProgramInstalled gh; then
  echo "Installing the Github CLI. Setting things up...."
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  gh config set git_protocol ssh --host github.com
  echo "Installed Github CLI"
else
  echo "The Github CLI has already been installed"
fi
echo -e "\n"

# shellcheck source=../../common/authenticateGithubCLI.sh
. "$commonScriptsDir/authenticateGithubCLI.sh"
echo -e "\n"

# shellcheck source=../../common/addSSHToGithub.sh
. "$commonScriptsDir/addSSHToGithub.sh" "Personal Laptop $(cat /etc/fedora-release)"
echo -e "\n"

# shellcheck source=../../common/bootstrapFsDirStructure.sh
. "$commonScriptsDir/bootstrapFsDirStructure.sh"
echo -e "\n"

# shellcheck source=../../common/cloneGitRepos.sh
. "$commonScriptsDir/cloneGitRepos.sh"
echo -e "\n"

# shellcheck source=../../common/setupNodeWithNVM.sh
. "$commonScriptsDir/setupNodeWithNVM.sh"
echo -e "\n"

# Install vscode
if ! isProgramInstalled code; then
  echo "Setting up vscode RPM repository..."
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  dnf check-update
  sudo dnf install code -y
  echo "Done"
else
  echo "Seems like vscode is already installed!"
fi
echo -e "\n"

sudo dnf update -y
echo -e "\n"

# Kernel devel is for OpenRazer. There is an issue on fedora that warrants its installation
# The g++ package is for this issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/626
echo "Installing other system packages..."

while IFS= read -r package; do
  LINUX_PACKAGES+=("$package")
done <"$commonScriptsDir/assets/packages.txt"

# So installations can happen in parallel
sudo dnf install -y "${LINUX_PACKAGES[@]}"
echo -e "System packages installed!\n"

# Installing ffmpeg for Firefox videos to work
# If these steps are not enough you can supplement them with the steps found here (https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/)
echo "Installing ffmpeg to avoid firefox video playback corruption"
sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install ffmpeg --allowerasing -y
echo "ffmpeg version: $(ffmpeg -version)"
echo -e "Done! FFmpeg has been installed\n"

# shellcheck source=./scripts/installChrome.sh
. "$fedoraDistroSetupDir/scripts/installChrome.sh"
echo -e "\n"

sudo dnf update -y
echo -e "\n"

# Install some miscellaneous CLIs using Python, Go, Rust, and Ruby
# shellcheck source=../../common/installMisc.sh
. "$commonScriptsDir/installMisc.sh"
echo -e "\n"

# Install Rust crates
# shellcheck source=../../common/installCrates.sh
. "$commonScriptsDir/installCrates.sh"
echo -e "\n"

# shellcheck source=./scripts/setupProtonvpn.sh
. "$fedoraDistroSetupDir/scripts/setupProtonvpn.sh"
echo -e "\n"

# shellcheck source=../../common/installGlobalNpmPackages.sh
. "$commonScriptsDir/installGlobalNpmPackages.sh"
echo -e "\n"

# Fix zsh-syntax-highlighting and zsh-autosuggestions
# shellcheck source=../../common/fixCustomZshPlugins.sh
source "$commonScriptsDir/fixCustomZshPlugins.sh"
echo -e "\n"

# shellcheck source=../../common/astroNvimSetup.sh
. "$commonScriptsDir/astroNvimSetup.sh"
echo -e "\n"

# shellcheck source=../../common/symlinkDotfiles.sh
. "$commonScriptsDir/symlinkDotfiles.sh"
echo -e "\n"

# shellcheck source=./scripts/createDnfAliases.sh
. "$fedoraDistroSetupDir/scripts/createDnfAliases.sh"
echo -e "\n"

# shellcheck source=../../common/restoreCronjobs.sh
. "$commonScriptsDir/restoreCronjobs.sh"
echo -e "\n"

# Install gh extensins
echo "Installing some gh CLI extensions"
source "$rootDir/common/ghExtensionsInstall.sh"

# Setting up automatic updates
if [[ $(systemctl list-timers dnf-automatic-install.timer --all) =~ "0 timers" ]]; then
  echo "Setting it up automatic updates"
  [[ -z $AUTO_UPDATES_GIST_URL ]] && gh gist view -r "$AUTO_UPDATES_GIST_URL" | sudo tee /etc/dnf/automatic.conf
  systemctl enable --now dnf-automatic-install.timer
  echo "Auto updates setup complete"
else
  echo "Auto sys updates are enabled"
fi
echo -e "\n"

# Install and setup openrazer and polychromatic
if ! (rpm -qa | grep -E "openrazer-meta|polychromatic") &>/dev/null; then
  echo "Setting up OpenRazer and polychromatic"
  sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:razer/Fedora_34/hardware:razer.repo
  sudo dnf install openrazer-meta polychromatic -y --skip-broken
  echo "Now you can use your mouse!! You'll need to reboot for updates to be completed"
  echo "Pleae re-run script"
  exit 0
else
  echo "Seems like OpenRazer is installed"
fi
echo -e "\n"

# Setup Snapcraft and install some snaps
source "$rootDir/common/setupSnapcraft.sh"

# Setup Flathub and install certain flatpaks
source "$rootDir/common/setupFlathub.sh"

# Install docker
if ! (rpm -qa | grep -E "docker|moby") &>/dev/null; then
  echo "Installing & enabling docker..."
  sudo dnf install moby-engine docker-compose -y
  sudo systemctl enable docker
  echo "Done!"
else
  echo "Seems like docker has already been installed"
fi
echo -e "\n"

sudo dnf update -y
echo -e "\n"

echo "Quick Break...."
sleep 3
echo "Getting back to work"
echo -e "\n"

# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
if ! (getent group docker | grep "$USER") &>/dev/null; then
  echo "Creating docker group"
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  echo "Done! You may need to logout and then back in to see the changes"
else
  echo "Seems like docker has already been installed and you have been added to the docker group"
fi
echo -e "\n"

# Install spicetify components
source "$rootDir/common/installSpicetifyComponents.sh"

source "$rootDir/common/installBetterdiscord.sh"

echo "Success! We're back baby!! Now for the things that could not be automated...."
echo -e "\n"

echo "Manual Steps"
cat "$fedoraDistroSetupDir/manualInstructions.md"
