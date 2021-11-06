#!/usr/bin/env bash

rootDir="$(dirname "$(dirname "$(dirname "$0")")")"
distroSetupDir="$(dirname "$0")"

if [ ! -f "$distroSetupDir/.env" ]; then
  echo "a .env file is required"
  exit 0
fi

source "$rootDir/common/isInstalled.sh"

sudo dnf update -y

# Install and setup oh-my-zsh and zsh
# Install ZSH
if [ "$(isNotInstalled "command -v zsh")" ]; then
  echo "Installing ZSH"
  sudo dnf install zsh util-linux-user -y
  echo "Done installing ZSH"
else
  echo "ZSH is already installed"
fi

# Set ZSH to default terminal
if [[ $SHELL != *"zsh" ]]; then
  echo "Setting ZSH as default shell"

  if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
    echo "It seems zsh is not amongst your list of authorized shells. Adding it"
    echo "$(which zsh)" | sudo tee -a /etc/shells
    echo "Done!"
  fi

  chsh -s "$(which zsh)"
  echo "Done! You may need to logout and log back in to see the effects"
fi

# Install Oh-My-ZSH
# First check for either the curl or wget commands
if [ "$(isNotInstalled "command -v curl")" ] && [ "$(isNotInstalled "command -v wget")" ]; then
  echo "You need to install either curl or wget in order to install oh-my-zsh"
  sudo dnf install wget curl -y
  echo "Installed curl and wget, just in case..."
fi

source "$rootDir/common/intallOMZ.sh"

# Install Git
if [ "$(isNotInstalled "command -v git")" ]; then
  echo "Seems like you do not have git installed :/"
  sudo dnf install git-all -y

  echo "Git successfully installed"
else
  echo "Seems you already have git installed"
fi

source "$rootDir/common/exposeENV.sh"
exposeEnvValues "$distroSetupDir/.env"

# Install Github CLI
if [ "$(isNotInstalled "command -v gh")" ]; then
  echo "Installing Github CLI. Setting things up...."
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  gh config set git_protocol ssh --host github.com
  echo "Installed Github CLI"

  if [ "$(isNotInstalled "gh auth status")" ]; then
    echo "Seems like you are not authenticated :(. Let's fix that"

    # Alternate Method
    echo "export GH_TOKEN=$GH_TOKEN" >"$HOME/.personal_token"

    echo "$TOKEN_FOR_GITHUB_CLI" >gh_token.txt
    < gh_token.txt gh auth login --with-token

    unset TOKEN_FOR_GITHUB_CLI
    rm gh_token.txt

    echo "Now you are :)"
  fi

  # Install gh extensins
  echo "Installing some gh CLI extensions"

  echo "Installing screensaver extension"
  [ "$(isNotInstalled "gh extension list | grep 'vilmibm/gh-screensaver'")" ] && gh extension install vilmibm/gh-screensaver
  echo "Screensaver extension installed"

  echo "Installing extension that allows you to delete repos from commandline"
  [ "$(isNotInstalled "gh extension list | grep 'mislav/gh-delete-repo'")" ] && gh extension install mislav/gh-delete-repo
  echo "gh-delete-repo extension installed"

  echo "Installing extension for viewing contribution graph"
  [ "$(isNotInstalled "gh extension list | grep 'kawarimidoll/gh-graph'")" ] && gh extension install kawarimidoll/gh-graph
  echo "Extension for viewing contribution graph installed"
fi

sudo dnf update -y

# Create desired filesystem structure
source "$rootDir/common/createDirStructure.sh"

# Clone repos
source "$rootDir/common/cloneGitRepos.sh"

# Create symlinks for dotfiles
source "$rootDir/common/symlinkDotfiles.sh"

# Install nvm
if [ "$(isNotInstalled "command -v nvm")" ]; then
  echo "Installing nmv..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
  source "$HOME/.zshrc"

  echo "NVM installed successfully, and .zshrc file reloaded"
fi

if [ "$(isNotInstalled "command -v nvm")" ]; then
  nvm -v
  echo "Seems there is an issue with the nvm installation"
  echo "nvm is needed to install node"
  echo "You may have to source the .zshrc file manually or something"
  exit 4
fi

# Install node
if [ "$(isInstalled "command -v nvm")" ]; then
  echo "Installing Node & NPM"
  nvm install node
  echo "Successfully installed Node & NPM"
fi

if [ "$(isInstalled "command -v node")" ] && [ "$(isInstalled "command -v npm")" ]; then
  echo "Great! Both npm and node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"
  echo "Checking npm installation...."
  npm doctor
fi

# Install global node packages
source "$rootDir/common/installGlobalNpmPackages.sh"

# Install vscode
if [ "$(isNotInstalled "command -v code")" ]; then
  echo "Installing vscode repository..."
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  dnf check-update
  sudo dnf install code -y
  echo "Done"
else
  echo "Seems like vscode is already installed!"
fi

# Install certain packages on fedora
# TODO there are some more packages

sudo dnf update -y

# Kernel devel is for OpenRazer. There is an issue on fedora that warrants its installation

echo "Installing some linux packages"
sudo dnf install -y protonvpn protonvpn-cli android-tools emoji-picker expect neofetch gnome-tweaks google-chrome hw-probe python3-pip snapd postgresql postgresql-server w3m ImageMagick dconf-editor dnf-automatic emoji-picker virt-manager code kernel-devel
echo "Installed."

# Setting up automatic updates
echo "Setting it up automatic updates"
gh gist view -r "$AUTO_UPDATES_GIST_URL" | sudo tee /etc/dnf/automatic.conf
systemctl enable --now dnf-automatic.timer
echo "Auto updates setup complete"

# Install and setup openrazer and polychromatic
echo "Setting up OpenRazer and polychromatic"
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/hardware:razer/Fedora_34/hardware:razer.repo
dnf install openrazer-meta polychromatic -y
echo "Now you can use your mouse!! You'll need to reboot for updates to be completed"

# Setup Flathub and install certain flatpaks
source "$rootDir/common/setupFlathub.sh"

# Setup Snapcraft and install some snaps
source "$rootDir/common/setupSnapcraft.sh"

# Install some miscellaneous CLIs wit pip
source "$rootDir/common/installMisc.sh"

# Customize Gnome theme
if [ ! -d "$HOME/customizations/WhiteSur-gtk-theme" ]; then
  echo "Seems like the Whitesur gtk theme hasn't been installed yet"
  echo "Install it before setting up the theme"
else
  echo "Setting up Whitesur GTK theme"
  cd "$HOME/customizations/WhiteSur-gtk-theme" || exit
  ./install.sh "-c dark" "-i fedora" "-N glassy"
  sudo ./tweaks.sh "-F" "-s" "-g"

  echo "Theme setup! You may need to logout then log back in to the changes"
fi

# Install docker
echo "Installing & enabling docker..."
sudo dnf install moby-engine docker-compose
sudo systemctl enable docker
echo "Done!"

# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
echo "Creating docker group"
sudo groupadd docker
sudo usermod -aG docker "$USER"
echo "Done!"

sudo dnf update -y

echo "Success! We're back baby!! No for th things that could not be automated...."
echo "Manual Steps"
printf "\n"

echo "  1. Install and setup postgres with pgAdmin"
echo "  2. Install Cascadia code font and import other fonts from google drive"
echo "  3. Restore backup files from google drive"
echo "  4. Install icon theme library (McMojave-cursors from the pling store)"
echo "  5. Run manual script (in /common/manuals) to restore important parts of the system"

echo "Now you may need to rebot your system to get some changes to actually take effect"
sudo systemctl reboot
