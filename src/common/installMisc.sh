#!/usr/bin/env bash

# Install some miscellaneous CLIs using Python, Go, Rust, and Ruby
# Requirements: Python-pip3, go, ruby, wget

if ! isProgramInstalled pip3 || ! isProgramInstalled curl || ! isProgramInstalled wget || ! isProgramInstalled go || ! isProgramInstalled gh; then
  echo "Seems like you're missing one of the following: pip3, curl, wget, go, or the GitHub CLI (gh)"
  echo "Please install the missing packages then re-run the script. Skipping..."
  return
fi

echo "Installing python packages..."
python -m pip install --upgrade pip wheel

# dnspython is a protonvpn dependency, pynvim is for astrovim
python -m pip install termdown thefuck dnspython pynvim virtualenv httpie

echo "Installation complete, the following packages were added"
python -m pip list
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
echo -e "\n"

# Lazydocker (https://github.com/jesseduffield/lazydocker)
echo "Installing lazydocker..."
if ! isProgramInstalled lazydocker; then
  go install github.com/jesseduffield/lazydocker@latest
  echo "lazydocker has been installed"
else
  echo "lazydocker has already been installed. Moving on..."
fi
echo -e "\n"

# Installing ChatGPT-CLI (https://github.com/0xacx/chatGPT-shell-cli)
echo "Installing ChatGPT CLI..."
if ! isProgramInstalled chatgpt; then
  curl -sS https://raw.githubusercontent.com/0xacx/chatGPT-shell-cli/main/chatgpt.sh -o $HOME/.local/bin/chatgpt

  # Replace open image command with xdg-open for linux systems
  if [[ "$OSTYPE" == "linux"* ]] || [[ "$OSTYPE" == "freebsd"* ]]; then
    sed -i 's/open "\${image_url}"/xdg-open "\${image_url}"/g' "$HOME/.local/bin/chatgpt"
  fi

  chmod +x $HOME/.local/bin/chatgpt
  echo "Installed chatgpt script to /usr/local/bin/chatgpt"
  echo "Note: This CLI requires the 'OPENAI_KEY' environment variable"
  echo "You can add this by instantiating the '.private_shell_env_template' file in your dotfiles, specifically the shell config group"
  echo "Once you've seeded it with the necessary values, rename it to '.private_shell_env'"
else
  echo "The ChatGPT CLI has already been installed. Moving on..."
fi
echo -e "\n"

echo "Installing keyb..."
if ! isProgramInstalled keyb; then
  go install github.com/kencx/keyb@latest
  echo "keyb has been installed!"
else
  echo "keyb has already been installed. Moving on..."
fi
echo -e "\n"
