#!/usr/bin/env bash

# Requires python3-pip

sudo dnf update -y
printf "\n"

if ! command -v pip3 &>/dev/null; then
  echo "Seems like pip3 is missing on the system. Try installing it?"
  exit 1
fi

# Install anime-downloader
if ! command -v anime &>/dev/null; then
  echo "Installing anime-downloader with pip3...."
  pip3 install anime-downloader
  echo "Installed anime-downloader $(anime --version)"
else
  echo "anime-downloader already intstalled"
fi
printf "\n"

# For tmp mail CLI
if ! command -v tmpmail &>/dev/null; then
  echo "Installing tmpmail cli...."
  wget https://raw.githubusercontent.com/sdushantha/tmpmail/master/tmpmail -P "$HOME"
  sudo chmod -v +x "$HOME/tmpmail"

  echo "Installed tmpmail cli"
else
  echo "tmpmail already installed"
fi
printf "\n"

# For termdown
if ! command -v termdown &>/dev/null; then
  echo "Installing termdown CLI timer..."
  pip install termdown
  echo "Installed termdown CLI timer"
else
  echo "termdown already installed"
fi
printf "\n"

# For Rust (https://www.rust-lang.org/tools/install)
if ! command -v rustup &>/dev/null; then
  echo "Installing rust!"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  echo "Rust installed"
else
  echo "Rust already installed"
fi
printf "\n"

# For fm6000 (https://github.com/anhsirk0/fetch-master-6000)
if ! command -v rustup &>/dev/null; then
  echo "Installing fetch master 6000"
  sh -c "$(curl https://raw.githubusercontent.com/anhsirk0/fetch-master-6000/master/install.sh)"
  echo "Fetch master 6000 Installed"
else
  echo "Fetch master 6000 already installed"
fi
printf "\n"

# For thefuck (https://github.com/nvbn/thefuck)
if ! command -v fuck &>/dev/null; then
  echo "Installing thefuck"
  python3 -m pip install thefuck
  echo "thefuck is Installed"
else
  echo "thefuck is already installed"
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

# noti (https://github.com/variadico/noti)
if ! command -v noti &>/dev/null; then
  echo "Installing noti"
  go get github.com/variadico/noti/cmd/noti
  echo "noti has been Installed"
else
  echo "noti is already installed"
fi
printf "\n"

# Some python packages
echo "Installing python packages (mypy, black)"
py -m pip install --no-binary mypy -U mypy
py -m pip install black
echo "python packages (mypy, black) installation done"
