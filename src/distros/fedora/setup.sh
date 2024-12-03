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

startSudoRefreshLoop

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

echo "Installing dnf5-plugins for the new dnf 5..."
if ! isPackageInstalled dnf5-plugins; then
  sudo dnf install dnf5-plugins
  echo "Installed dnf5-plugins package..."
else
  echo "dnf5-plugins has already been installed"
fi
echo -e "\n"

if isPackageInstalled libcurl-minimal; then
  # https://discussion.fedoraproject.org/t/command-line-updating-issues/135369
  echo "Swapping libcurl-minimal for libcurl..."
  sudo dnf swap -y libcurl-minimal libcurl
  sudo dnf update -y
  echo "Swapped libcurl-minimal for libcurl..."
  echo -e "\n"
fi

# shellcheck source=../../common/installOMZ.sh
. "$commonScriptsDir/installOMZ.sh"
echo -e "\n"

exposeEnvValues "$fedoraDistroSetupDir/.env"

echo "Installing the Github CLI..."
if ! isProgramInstalled gh; then
  sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install -y gh --repo gh-cli

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

# shellcheck source=../../common/setupZshPlugins.sh
source "$commonScriptsDir/setupZshPlugins.sh"
echo -e "\n"

# shellcheck source=./scripts/installDocker.sh
. "$fedoraDistroSetupDir/scripts/installDocker.sh"
echo -e "\n"

# Install vscode
echo "Installing vscode from RPM repository..."
if ! isProgramInstalled code; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

  dnf check-update
  sudo dnf install -y code
  echo "Done"
else
  echo "Seems like vscode has already been installed!"
fi
echo -e "\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

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
  echo "Looks like the package install failed, hmmmm. Exiting for safe measure..."
  exit 1
fi

echo -e "System packages installed!\n"

echo "Updating installed packages..."
sudo dnf update -y
echo -e "Done!\n"

# shellcheck source=../../common/addPipxToPath.sh
source "$commonScriptsDir/addPipxToPath.sh"
echo -e "\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

# shellcheck source=./scripts/installChrome.sh
. "$fedoraDistroSetupDir/scripts/installChrome.sh"
echo -e "\n"

# shellcheck source=./scripts/installProtonvpn.sh
. "$fedoraDistroSetupDir/scripts/installProtonvpn.sh"
echo -e "\n"

# Installing node depends on NVM
# shellcheck source=../../common/setupNodeWithNVM.sh
. "$commonScriptsDir/setupNodeWithNVM.sh"
echo -e "\n"

# shellcheck source=../../common/installMisc.sh
. "$commonScriptsDir/installMisc.sh"
echo -e "\n"

# shellcheck source=../../common/astroNvimSetup.sh
. "$commonScriptsDir/astroNvimSetup.sh"
echo -e "\n"

# shellcheck source=../../common/installCrates.sh
. "$commonScriptsDir/installCrates.sh"
echo -e "\n"

# shellcheck source=../../common/installGlobalNpmPackages.sh
. "$commonScriptsDir/installGlobalNpmPackages.sh"
echo -e "\n"

# shellcheck source=../../common/symlinkDotfiles.sh
. "$commonScriptsDir/symlinkDotfiles.sh"
echo -e "\n"

# Depends on dotfiles being available
# shellcheck source=../../common/restoreCronjobs.sh
. "$commonScriptsDir/restoreCronjobs.sh"
echo -e "\n"

# Depends on dotfiles being available
# shellcheck source=../../common/ghExtensionsInstall.sh
. "$commonScriptsDir/ghExtensionsInstall.sh"
echo -e "\n"

# Depends on dotfiles being available
# shellcheck source=../../common/ghAliasRestore.sh
. "$commonScriptsDir/ghAliasRestore.sh"
echo -e "\n"

echo -e "Quick Break...\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work\n"

# Setting up automatic updates
echo "Setting it up automatic updates..."
if [[ $(systemctl list-timers 'dnf-automatic-install.timer' 'dnf5-automatic.timer') =~ "0 timers" ]]; then
  sudo dnf install -y --allowerasing dnf5-plugin-automatic
  gh gist view -r '5cc6a37d1c9fc687d241a802a98c9db7' | sudo tee /etc/dnf/automatic.conf >/dev/null
  sudo systemctl enable --now dnf5-automatic.timer
  echo "Auto updates have been setup successfully"
else
  echo "Auto updates have already been enabled"
fi
echo -e "\n"

# shellcheck source=../../common/setupFlathub.sh
. "$commonScriptsDir/setupFlathub.sh"
echo -e "\n"

# shellcheck source=./scripts/installHaskell.sh
. "$fedoraDistroSetupDir/scripts/installHaskell.sh"
echo -e "\n"

# shellcheck source=../../common/installHaskellExecs.sh
. "$commonScriptsDir/installHaskellExecs.sh"
echo -e "\n"

# shellcheck source=./scripts/installNvidiaContainerKit.sh
. "$fedoraDistroSetupDir/scripts/installNvidiaContainerKit.sh"
echo -e "\n"

# shellcheck source=./scripts/multiMediaSetup.sh
. "$fedoraDistroSetupDir/scripts/multiMediaSetup.sh"
echo -e "\n"

# shellcheck source=../../common/ricing/gnome/catppuccin/cursors.sh
. "$commonScriptsDir/ricing/gnome/catppuccin/cursors.sh"
echo -e "\n"

# shellcheck source=../../common/ricing/gnome/colloid/icons.sh
. "$commonScriptsDir/ricing/gnome/colloid/icons.sh"
echo -e "\n"

echo "Success! We're so back baby!! Now for the things that could not be automated...."
echo "For those, you can refer to the manual instructions"
cat "$fedoraDistroSetupDir/assets/manualInstructions.md"

stopSudoRefreshLoop
