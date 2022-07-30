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

# dnspython is a protonvpn dependency, pynvim is for astrovim
python3 -m pip install black anime-downloader termdown thefuck dnspython pynvim --no-warn-script-location

echo "python packages installation done. Installed the following packages:"
python3 -m pip list
printf "\n"

# For Rust (https://www.rust-lang.org/tools/install)
# To run unattended (https://github.com/rust-lang/rustup/issues/297)
if ! command -v rustup &>/dev/null; then
  echo "Installing rust!"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
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
if [[ ! -f "$HOME/.local/bin/noti" ]]; then
  echo "Installing noti"
  curl -L "$(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'linux-amd64' | sed 's/"//g')" | tar -xz 
  mv -v noti "$HOME/.local/bin"
  echo "noti has been Installed"
else
  echo "noti is already installed"
fi
printf "\n"

# Bun (https://bun.sh/)
if ! command -v bun &>/dev/null; then
  echo "Installing bun..."
  curl https://bun.sh/install | bash
  echo -e "Bun installed\n"
else
  echo -e "Bun is already installed\n"
fi

# Ngrok (https://ngrok.com/docs/getting-started)
if ! command -v ngrok &>/dev/null; then
  echo "Downloading ngrok..."
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  echo -e "ngrok is download complete!\n"

  echo "Extracting..."
  sudo tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
  rm ngrok-v3-stable-linux-amd64.tgz
  echo -e "Extraction complete\n"
else
  echo -e "Ngrok has already been installed! Though you will still need to authenticate\n "
fi
