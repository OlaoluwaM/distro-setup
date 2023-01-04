#!/usr/bin/env bash

# shellcheck disable=SC2317

fedoraDistroSetupDir="$(dirname "$0")"
rootDir="$(dirname "$(dirname "$fedoraDistroSetupDir")")"
commonScriptsDir="$rootDir/common"

# To expose utilities for later use
# shellcheck source=../../common/_internals.sh
. "$commonScriptsDir/_internals.sh"

if ! doesFileExist "$fedoraDistroSetupDir/.env"; then
  echo "A .env file is required. Check the template at $fedoraDistroSetupDir/assets/env_template.txt for the required variables. Exiting..."
  exit 1
fi

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo "Installing ZSH..."
if ! isProgramInstalled zsh; then
  sudo dnf install zsh util-linux-user -y
  echo "Done!"
else
  echo "ZSH has already been installed"
fi
echo -e "\n"

# shellcheck source=../../common/setupZsh.sh
. "$commonScriptsDir/setupZsh.sh"
echo -e "\n"

echo "Installing git..."
if ! isProgramInstalled git; then
  sudo dnf install git-all -y
  echo "Git successfully installed!"
else
  echo "Git has already been installed"
fi
echo -e "\n"

echo "Installing curl and wget..."
if ! isProgramInstalled curl && ! isProgramInstalled wget; then
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

echo "Installing the Github CLI..."
if ! isProgramInstalled gh; then
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  gh config set git_protocol ssh --host github.com
  echo "The Github CLI has been installed"
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

# shellcheck source=./scripts/installDocker.sh
. "$fedoraDistroSetupDir/scripts/installDocker.sh"
echo -e "\n"

# Install vscode
echo "Installing vscode from RPM repository..."
if ! isProgramInstalled code; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  dnf check-update
  sudo dnf install code -y
  echo "Done"
else
  echo "Seems like vscode has already been installed!"
fi
echo -e "\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

# kernel-devel is for OpenRazer. There is an issue on fedora that warrants its installation
# The g++ package is for this issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/626
# The g++ package is also needed to compile the difftastic rust crate
echo "Installing system packages..."

while IFS= read -r package; do
  LINUX_PACKAGES+=("$package")
done <"$commonScriptsDir/assets/packages.txt"

# So installations can happen in parallel
sudo dnf install -y "${LINUX_PACKAGES[@]}"

# shellcheck disable=SC2181
if [[ $? -ne 0 ]]; then
  echo "Looks like the package install failed, hmmmm.Exiting for safe measure..."
  exit 1
fi

echo -e "System packages installed!\n"

# shellcheck source=./scripts/installChrome.sh
. "$fedoraDistroSetupDir/scripts/installChrome.sh"
echo -e "\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

# shellcheck source=../../common/installMisc.sh
. "$commonScriptsDir/installMisc.sh"
echo -e "\n"

# shellcheck source=../../common/installCrates.sh
. "$commonScriptsDir/installCrates.sh"
echo -e "\n"

# shellcheck source=./scripts/installProtonvpn.sh
. "$fedoraDistroSetupDir/scripts/installProtonvpn.sh"
echo -e "\n"

# shellcheck source=../../common/installGlobalNpmPackages.sh
. "$commonScriptsDir/installGlobalNpmPackages.sh"
echo -e "\n"

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

# shellcheck source=../../common/ghExtensionsInstall.sh
. "$commonScriptsDir/ghExtensionsInstall.sh"
echo -e "\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

# Setting up automatic updates
echo "Setting it up automatic updates..."
if [[ $(systemctl list-timers dnf-automatic-install.timer --all) =~ "0 timers" ]]; then
  [[ -z $AUTO_UPDATES_GIST_URL ]] && gh gist view -r "$AUTO_UPDATES_GIST_URL" | sudo tee /etc/dnf/automatic.conf
  systemctl enable --now dnf-automatic-install.timer
  echo "Auto updates have been setup successfully"
else
  echo "Auto updates have already been enabled"
fi
echo -e "\n"

# shellcheck source=./scripts/installOpenrazer.sh
. "$fedoraDistroSetupDir/scripts/installOpenrazer.sh"
echo -e "\n"

# shellcheck source=../../common/setupSnapcraft.sh
. "$commonScriptsDir/setupSnapcraft.sh"
echo -e "\n"

# shellcheck source=../../common/setupFlathub.sh
. "$commonScriptsDir/setupFlathub.sh"
echo -e "\n"

# shellcheck source=../../common/installSpicetifyComponents.sh
. "$commonScriptsDir/installSpicetifyComponents.sh"
echo -e "\n"

# shellcheck source=./scripts/installBetterdiscord.sh
. "$fedoraDistroSetupDir/scripts/installBetterdiscord.sh"
echo -e "\n"

# shellcheck source=../../common/installSpeedtestCli.sh
. "$commonScriptsDir/installSpeedtestCli.sh"
echo -e "\n"

# shellcheck source=./scripts/installHaskell.sh
. "$fedoraDistroSetupDir/scripts/installHaskell.sh"
echo -e "\n"

echo "Success! We're back baby!! Now for the things that could not be automated...."
echo "For those, you can refer to the manual instructions"
cat "$fedoraDistroSetupDir/assets/manualInstructions.md"
