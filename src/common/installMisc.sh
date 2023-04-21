#!/usr/bin/env bash

# Install some miscellaneous CLIs using Python, Go, Rust, and Ruby
# Requirements: Python-pip3, go, ruby, wget

if ! isProgramInstalled pip3 || ! isProgramInstalled curl || ! isProgramInstalled wget || ! isProgramInstalled go || ! isProgramInstalled gem; then
  echo "Seems like you're missing one of the following: pip3, curl, wget, gem (ruby), or go."
  echo "Please install the missing packages then re-run the script. Skipping..."
  return
fi

echo "Installing python packages..."
python3 -m pip install --upgrade pip --no-warn-script-location
python3 -m pip install mypy -U mypy --no-warn-script-location

# dnspython is a protonvpn dependency, pynvim is for astrovim
python3 -m pip install black anime-downloader yt-dlp termdown thefuck dnspython pynvim virtualenv httpie --no-warn-script-location

echo "Installation complete, the following packages were added"
python3 -m pip list
echo -e "\n"

# For Rust (https://www.rust-lang.org/tools/install)
# To run unattended (https://github.com/rust-lang/rustup/issues/297)
echo "Installing rust..."
if ! isProgramInstalled rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

  echo -e "\nSourcing..."
  source $HOME/.cargo/env
  echo "Rust has been installed"
else
  echo "Rust has already been installed. Moving on..."
fi
echo -e "\n"

# For fm6000 (https://github.com/anhsirk0/fetch-master-6000)
echo "Installing fetch master 6000..."
if ! isProgramInstalled fm6000; then
  sh -c "$(curl https://raw.githubusercontent.com/OlaoluwaM/fetch-master-6000/add-option-for-headless-install/install.sh)" -- -y
  echo "Fetch master 6000 has been installed"
else
  echo "Fetch master 6000 has already been installed. Moving on..."
fi
echo -e "\n"

# Lazygit (https://github.com/jesseduffield/lazygit)
echo "Installing lazygit..."
if ! isProgramInstalled lazygit; then
  go install github.com/jesseduffield/lazygit@latest
  echo "lazygit has been installed"
else
  echo "lazygit has already been installed. Moving on..."
fi
echo -e "\n"

# Colorls (https://github.com/athityakumar/colorls#installation)
echo "Installing colorls..."
if ! isProgramInstalled colorls; then
  gem install colorls
  echo "colorls has been installed"
else
  echo "colorls has already been installed. Moving on..."
fi
echo -e "\n"

# noti (https://github.com/variadico/noti)
echo "Installing noti..."
if ! doesFileExist "$HOME/.local/bin/noti"; then
  curl -L "$(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'linux-amd64' | sed 's/"//g')" | tar -xz
  mv -v noti "$HOME/.local/bin"
  echo "noti has been Installed"
else
  echo "noti has already been installed. Moving on..."
fi
echo -e "\n"

# Bun (https://bun.sh/)
echo "Installing bun..."
if ! isProgramInstalled bun; then
  curl -fsSL https://bun.sh/install | bash
  echo "Bun has been installed"
else
  echo "Bun has already been installed. Moving on..."
fi
echo -e "\n"

# Ngrok (https://ngrok.com/docs/getting-started)
echo "Installing ngrok..."
if ! isProgramInstalled ngrok; then
  echo "Downloading ngrok..."
  wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  echo -e "ngrok download complete!"

  echo "Extracting download..."
  sudo tar xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin
  rm ngrok-v3-stable-linux-amd64.tgz
  echo "Extraction complete"
else
  echo "Ngrok has already been installed! Though you will still need to authenticate to use it. Moving on..."
fi
echo -e "\n"

# Install cheatsheet cli with cheat
echo "Installing the cheat CLI..."
if ! isProgramInstalled cheat; then
  go install github.com/cheat/cheat/cmd/cheat@latest
  echo -e "The cheat CLI has been installed!"
else
  echo "The cheat CLI has already been installed. Moving on..."
fi
echo -e "\n"

# Install fx interactive JSON traversal tool (https://github.com/antonmedv/fx)
echo "Installing fx..."
if ! isProgramInstalled fx; then
  go install github.com/antonmedv/fx@latest
  echo "fx has been installed"
else
  echo "fx has already been installed. Moving on..."
fi
