#!/usr/bin/env bash

rootDir="$(dirname "$(dirname "$(dirname "$0")")")"
distroSetupDir="$(dirname "$0")"

if [ ! -f "$distroSetupDir/.env" ]; then
  echo "a .env file is required"
  exit 0
fi

sudo dnf update -y
printf "\n"

# Install and setup oh-my-zsh and zsh
# Install ZSH
if ! command -v zsh &>/dev/null; then
  echo "Installing ZSH"
  sudo dnf install zsh util-linux-user -y
  echo "Done installing ZSH"
else
  echo "ZSH is already installed"
fi
printf "\n"

# Set ZSH to default terminal
if [[ $SHELL != *"zsh" ]]; then
  echo "Setting ZSH as default shell"

  if [[ "$(cat /etc/shells)" == *"zsh" ]]; then
    echo "It seems zsh is not amongst your list of authorized shells. Adding it"
    echo "$(which zsh)" | sudo tee -a /etc/shells
    echo "Done!"
    printf "\n"
  fi

  echo "Creating placeholder .zshrc file..."
  touch "$HOME/.zshrc"
  echo "# This is a placeholder file" >"$HOME/.zshrc"
  echo "Done!"
  printf "\n"

  chsh -s "$(which zsh)"
  echo "Done! You may need to logout and log back in to see the effects"
  exit 0
else
  echo "Seems like ZSH is already the default shell"
fi
printf "\n"

# First check for either the curl or wget commands
if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
  echo "You need to install either curl or wget in order to install oh-my-zsh"
  sudo dnf install wget curl -y
  echo "Installed curl and wget, just in case..."
  printf "\n"
fi

# Install Git
if ! command -v git &>/dev/null; then
  echo "Seems like you do not have git installed :/"
  sudo dnf install git-all -y

  echo "Git successfully installed"
else
  echo "Seems you already have git installed"
fi
printf "\n"

source "$rootDir/common/exposeENV.sh"
exposeEnvValues "$distroSetupDir/.env"

# Install Github CLI
if ! command -v gh &>/dev/null; then
  echo "Installing Github CLI. Setting things up...."
  sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh -y

  gh config set git_protocol ssh --host github.com
  echo "Installed Github CLI"

  printf "\n"
fi

echo "Quick Break...."
sleep 5
echo "Getting back to work"

# Authenticate Github CLI
if ! gh auth status &>/dev/null; then
  echo "Seems like you are not authenticated :(. Let's fix that"

  # Alternate Method
  echo "export GH_TOKEN=$TOKEN_FOR_GITHUB_CLI" >"$HOME/.personal_tokens"

  echo "$TOKEN_FOR_GITHUB_CLI" >gh_token.txt
  gh auth login --with-token <gh_token.txt

  unset TOKEN_FOR_GITHUB_CLI
  rm gh_token.txt

  printf "\n"
  echo "Checking auth status"
  gh auth status
  echo "Now you are :)"
fi
printf "\n"

sudo dnf update -y
printf "\n"

echo "Quick Break...."
sleep 10
echo "Getting back to work"

# Setup SSH keys for github
source "$rootDir/common/addSSHToGithub.sh" "Personal Laptop $(cat /etc/fedora-release)"

# Create desired filesystem structure
source "$rootDir/common/createDirStructure.sh"

echo "Quick Break...."
sleep 5
echo "Getting back to work"

# Clone repos
source "$rootDir/common/cloneGitRepos.sh"

# Install nvm
nvmInstalled=$([ -d "$HOME/.nvm" ] && echo true || echo false)

if [[ $nvmInstalled == false ]]; then
  echo "Installing nmv..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

  echo "NVM installed successfully"

  echo "Seems like a reload is in order to get nvm up and running. You can handle that right?"
  echo "When you are done, re-run this script ;)"
  exit 0

fi

if [[ $nvmInstalled == false ]]; then
  echo "Seems there is an issue with the nvm installation"
  echo "nvm is needed to install node"
  echo "You may have to source the .zshrc file manually or something"
  exit 1
fi

# Install node
if [[ $nvmInstalled == true ]] && ! command -v node &>/dev/null; then
  source "$HOME/.zshrc"
  echo "Installing Node & NPM"
  nvm install node
  echo "Successfully installed Node & NPM"
  printf "\n"
fi

if command -v node &>/dev/null && command -v npm &>/dev/null; then
  echo "Great! Both npm and node have been installed"
  echo "Node version is $(node -v)"
  echo "NPM version is $(npm -v)"
  printf "\n"

  echo "Checking npm installation...."
  npm doctor
  printf "\n"
fi

# Install Oh-My-ZSH
source "$rootDir/common/installOMZ.sh"

# Create symlinks for dotfiles
source "$rootDir/common/symlinkDotfiles.sh"

# Fix zsh-syntax-highlighting and zsh-autosuggestions
source "$rootDir/common/fixCustomZshPlugins.sh"

# Install gh extensins
echo "Installing some gh CLI extensions"
source "$rootDir/common/ghExtensionsInstall.sh"

# Setup dnf command aliases
source "$rootDir/common/createDnfAliases.sh"

# Install global node packages
source "$rootDir/common/installGlobalNpmPackages.sh"

# Setup spachip-prompt
source "$rootDir/common/setupSpaceshipPrompt.sh"

# Install vscode
if ! command -v code &>/dev/null; then
  echo "Installing vscode repository..."
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

  dnf check-update
  sudo dnf install code -y
  echo "Done"
else
  echo "Seems like vscode is already installed!"
fi

sudo dnf update -y
printf "\n"

echo "Quick Break...."
sleep 3
echo "Getting back to work"

# Kernel devel is for OpenRazer. There is an issue on fedora that warrants its installation

echo "Installing some linux packages"
packages=("protonvpn" "android-tools" "emoji-picker" "expect" "neofetch" "gnome-tweaks" "hw-probe" "python3-pip" "snapd" "postgresql" "postgresql-server" "w3m" "ImageMagick" "dconf-editor" "dnf-automatic" "virt-manager" "code" "kernel-devel" "deja-dup" "neovim" "tilix" "fd-find" "cmatrix" "gnome-sound-recorder" "ffmpeg" "meld" "perl-experimental" "tldr" "cava" "ruby" "ruby-devel" "httpie" "bat" "ncdu" "fdupes" "libwebp-tools" "zathura" "exa" "7z" "ripgrep" "webp-pixbuf-loader" "no-more-secrets" "youtube-dl" "cmake" "prename" "speedtest-cli" "google-chrome" "golang" "starship" "zoxide" "libappindicator-gtk3" "gnome-shell-extension-appindicator" "cbonsai" "wl-clipboard" "direnv")

# So things run faster
sudo dnf install -y "${packages[@]}"

# The below is for if I want to install packages one by one
# for package in "${packages[@]}"; do
#   if (rpm -qa | grep "$package") &>/dev/null; then
#     echo "Seems like $package is already installed. Skipping...."
#   else
#     echo "Installing $package....."
#     sudo dnf install -y "$package"
#     echo "Installed."
#   fi
#   printf "\n"
# done

echo "Quick Break...."
sleep 12
echo "Getting back to work"
printf "\n"

sudo dnf update -y
printf "\n"

# Setting up automatic updates
if [[ $(systemctl list-timers dnf-automatic-install.timer --all) =~ "0 timers" ]]; then
  echo "Setting it up automatic updates"
  [[ -z $AUTO_UPDATES_GIST_URL ]] && gh gist view -r "$AUTO_UPDATES_GIST_URL" | sudo tee /etc/dnf/automatic.conf
  systemctl enable --now dnf-automatic-install.timer
  echo "Auto updates setup complete"
else
  echo "Auto sys updates are enabled"
fi
printf "\n"

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
printf "\n"

echo "Quick Break...."
sleep 4
echo "Getting back to work"

# Setup Snapcraft and install some snaps
source "$rootDir/common/setupSnapcraft.sh"

# Setup Flathub and install certain flatpaks
source "$rootDir/common/setupFlathub.sh"

# Install some miscellaneous CLIs wit pip
source "$rootDir/common/installMisc.sh"

echo "Quick Break...."
sleep 5
echo "Getting back to work"

# Install docker
if ! (rpm -qa | grep -E "docker|moby") &>/dev/null; then
  echo "Installing & enabling docker..."
  sudo dnf install moby-engine docker-compose -y
  sudo systemctl enable docker
  echo "Done!"
else
  echo "Seems like docker has already been installed"
fi
printf "\n"

sudo dnf update -y
printf "\n"

echo "Quick Break...."
sleep 3
echo "Getting back to work"

# Create docker group and add user to it so docker commands do not need to be prefixed with sudo
if ! (getent group docker | grep "$USER") &>/dev/null; then
  echo "Creating docker group"
  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  echo "Done! You may need to logout and then back in to see the changes"
else
  echo "Seems like docker has already been installed and you have been added to the docker group"
fi
printf "\n"

echo "Quick Break...."
sleep 3
echo "Getting back to work"
printf "\n"

source "$rootDir/common/betterdiscord.sh"
printf "\n"

echo "Success! We're back baby!! Now for the things that could not be automated...."
printf "\n"

echo "Manual Steps"
cat "$distroSetupDir/manualInstructions.md"
