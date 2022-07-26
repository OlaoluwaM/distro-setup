#!/usr/bin/env bash

# Requires python3-pip

sudo dnf update -y
printf "\n"

if ! command -v pip3 &>/dev/null; then
  echo "Seems like pip3 is missing on the system. Try installing it?"
  exit 1
fi

# Some python packages
echo "Installing python packages "
python3 -m pip install --upgrade pip --no-warn-script-location
python3 -m pip install --no-binary mypy -U mypy --no-warn-script-location
python3 -m pip install black anime-downloader termdown thefuck --no-warn-script-location

echo "python packages installation done. Installed the following packages:"
python3 -m pip list
printf "\n"

# For Rust (https://www.rust-lang.org/tools/install)
if ! command -v rustup &>/dev/null; then
  echo "Installing rust!"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y
  echo "Rust installed"
else
  echo "Rust already installed"
fi
printf "\n"

# For fm6000 (https://github.com/anhsirk0/fetch-master-6000)
if ! command -v fm6000 &>/dev/null; then
  echo "Installing fetch master 6000"
  sh -c "$(curl https://raw.githubusercontent.com/OlaoluwaM/fetch-master-6000/add-option-for-headless-install/install.sh)" -- -y
  echo "Fetch master 6000 Installed"
else
  echo "Fetch master 6000 already installed"
fi
printf "\n"

# Lazygit (https://github.com/jesseduffield/lazygit)
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit"
  go install github.com/jesseduffield/lazygit@latest
  echo "lazygit has been Installed"
else
  echo "lazygit is already installed"
fi
printf "\n"

# Colorls (https://github.com/athityakumar/colorls#installation)
if ! command -v colorls &>/dev/null; then
  echo "Installing colorls"
  gem install colorls
  echo "Colorls has been Installed"
else
  echo "Colorls is already installed"
fi
printf "\n"

# noti (https://github.com/variadico/noti)
if ! command -v noti &>/dev/null; then
  echo "Installing noti"
  curl -L "$(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'linux-amd64' | sed 's/"//g')" | tar -xz | xargs -I _ mv -t "$HOME/.local/bin" _
  echo "noti has been Installed"
else
  echo "noti is already installed"
fi
printf "\n"
