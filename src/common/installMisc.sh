#!/usr/bin/env bash

# Install some miscellaneous CLIs using Python, Go, Rust, and Ruby
# Requirements: Python-pip3, go, ruby, wget, pipx

if ! isProgramInstalled pipx || ! isProgramInstalled pip3 || ! isProgramInstalled curl || ! isProgramInstalled wget || ! isProgramInstalled go || ! isProgramInstalled gh; then
	echo "Seems like you're missing one of the following: pip3, pipx, curl, wget, go, or the GitHub CLI (gh)"
	echo "Please install the missing packages then re-run the script. Skipping..."
	return
fi

echo "Updating pip..."
python -m pip install --upgrade pip wheel --no-warn-script-location
echo -e "Done\n"

echo "Installing python executables with pipx..."
pipx install termdown ipython
echo -e "Installation complete\n"

echo "Installing python libraries with pip..."
# dnspython is a protonvpn dependency, pynvim is for astrovim
python3 -m pip install dnspython pynvim
echo -e "Installation complete\n"

# For Rust (https://www.rust-lang.org/tools/install)
# To run unattended (https://github.com/rust-lang/rustup/issues/297)
# https://github.com/rust-lang/rustup/issues/2040
echo "Installing rust..."
if ! isProgramInstalled rustup; then
	# https://github.com/rust-lang/rustup/issues/3706
	mkdir -p ~/.config/fish/conf.d/
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

	echo -e "\nSourcing..."
	source $HOME/.cargo/env
	echo "Rust has been installed"
else
	echo "Rust has already been installed. Moving on..."
fi
echo -e "\n"

# Install 'cargo binstall' and use that to install your rust binaries instead of cargo install (https://github.com/cargo-bins/cargo-binstall/tree/main)
echo "Installing cargo-binstall..."
if ! isProgramInstalled cargo-binstall; then
	curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
	echo "cargo-binstall has been installed"
else
	echo "cargo-binstall has already been installed. Moving on..."
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

# uv for mcp stuff (https://docs.astral.sh/uv/#installation)
echo "Installing uv..."
if ! isProgramInstalled uv; then
	curl -LsSf https://astral.sh/uv/install.sh | sh
	echo "uv has been Installed"
else
	echo "uv has already been installed. Moving on..."
fi
echo -e "\n"

# yt-dlp for downloading youtube videos (https://github.com/yt-dlp/yt-dlp)
echo "Installing yt-dlp..."
if ! isProgramInstalled yt-dlp; then
	curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$CUSTOM_BIN_DIR/yt-dlp"
	chmod +x "$CUSTOM_BIN_DIR/yt-dlp"
	echo "yt-dlp has been Installed"
else
	echo "yt-dlp has already been installed. Moving on..."
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

# Install shfmt (https://github.com/mvdan/sh)
echo "Installing shfmt..."
if ! isProgramInstalled shfmt; then
	go install mvdan.cc/sh/v3/cmd/shfmt@latest
	echo "shfmt has been installed"
else
	echo "shfmt has already been installed. Moving on..."
fi
echo -e "\n"

# https://github.com/junegunn/fzf
echo "Installing fzf..."
if ! isProgramInstalled fzf; then
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	~/.fzf/install --all --key-bindings --completion --update-rc --no-fish --no-bash
	echo "fzf has been installed!"
else
	echo "fzf has already been installed. Moving on..."
fi
