#!/usr/bin/env bash

# Install some miscellaneous CLIs using Python, Go, Rust, and Ruby
# Requirements: Python-pip3, go, ruby, wget

if ! isProgramInstalled pip3 || ! isProgramInstalled curl || ! isProgramInstalled wget || ! isProgramInstalled go || ! isProgramInstalled gh; then
	echo "Seems like you're missing one of the following: pip3, curl, wget, go, or the GitHub CLI (gh)"
	skipStep "Please install the missing packages, then re-run this script."
	return
fi

customBinDir="${CUSTOM_BIN_DIR:-$HOME/.local/bin}"
runOrFail "Could not create $customBinDir." mkdir -p "$customBinDir"

# replaces pipx (https://docs.astral.sh/uv/#installation)
echo "Installing uv..."
if ! isProgramInstalled uv; then
	if ! curl -LsSf https://astral.sh/uv/install.sh | sh; then
		failSetup "Could not install uv."
	fi
	success "uv installed"
else
	alreadyDone "uv is installed"
fi
echo -e "\n"

echo "Updating pip..."
runOrFail "Could not update pip and wheel." python3 -m pip install --upgrade pip wheel --no-warn-script-location
success "pip and wheel updated"
echo -e "\n"

echo "Installing python executables with uv..."
pythonTools=("termdown:termdown" "ipython:ipython" "notebooklm-mcp-cli:nlm" "pgcli:pgcli")
for toolSpec in "${pythonTools[@]}"; do
	packageName="${toolSpec%%:*}"
	commandName="${toolSpec##*:}"

	if isProgramInstalled "$commandName"; then
		alreadyDone "$commandName is installed"
		continue
	fi

	runOrFail "Could not install $packageName with uv." uv tool install "$packageName"
	success "$packageName installed with uv"
done
success "Python executable step complete"
echo -e "\n"

echo "Installing python libraries with pip..."
# dnspython is a protonvpn dependency, pynvim is for astrovim
runOrFail "Could not install Python libraries with pip." python3 -m pip install dnspython pynvim
success "Python libraries installed with pip"
echo -e "\n"

# For Rust (https://www.rust-lang.org/tools/install)
# To run unattended (https://github.com/rust-lang/rustup/issues/297)
# https://github.com/rust-lang/rustup/issues/2040
echo "Installing rust..."
if ! isProgramInstalled rustup; then
	# https://github.com/rust-lang/rustup/issues/3706
	runOrFail "Could not create fish config directory for rustup." mkdir -p "$HOME/.config/fish/conf.d/"
	if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y; then
		failSetup "Could not install Rust with rustup."
	fi

	echo -e "\nSourcing..."
	# shellcheck source=/dev/null
	runOrFail "Could not source $HOME/.cargo/env after installing Rust." source "$HOME/.cargo/env"
	success "Rust installed"
else
	alreadyDone "Rust is installed"
fi
echo -e "\n"

# Install 'cargo binstall' and use that to install your rust binaries instead of cargo install (https://github.com/cargo-bins/cargo-binstall/tree/main)
echo "Installing cargo-binstall..."
if ! isProgramInstalled cargo-binstall; then
	if ! curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash; then
		failSetup "Could not install cargo-binstall."
	fi
	success "cargo-binstall installed"
else
	alreadyDone "cargo-binstall is installed"
fi
echo -e "\n"

# noti (https://github.com/variadico/noti)
echo "Installing noti..."
if ! doesFileExist "$HOME/.local/bin/noti"; then
	notiDownloadUrl="$(curl -s https://api.github.com/repos/variadico/noti/releases/latest | awk '/browser_download_url/ { print $2 }' | grep 'linux-amd64' | sed 's/"//g')"
	if [[ -z "$notiDownloadUrl" ]]; then
		failSetup "Could not determine the latest noti Linux download URL."
	fi
	if ! curl -L "$notiDownloadUrl" | tar -xz; then
		failSetup "Could not download and unpack noti."
	fi
	runOrFail "Could not move noti into $HOME/.local/bin." mv -v noti "$HOME/.local/bin"
	success "noti installed"
else
	alreadyDone "noti is installed"
fi
echo -e "\n"

# yt-dlp for downloading youtube videos (https://github.com/yt-dlp/yt-dlp)
echo "Installing yt-dlp..."
if ! isProgramInstalled yt-dlp; then
	runOrFail "Could not download yt-dlp." curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$customBinDir/yt-dlp"
	runOrFail "Could not make yt-dlp executable." chmod +x "$customBinDir/yt-dlp"
	success "yt-dlp installed"
else
	alreadyDone "yt-dlp is installed"
fi
echo -e "\n"

# Install cheatsheet cli with cheat
echo "Installing the cheat CLI..."
if ! isProgramInstalled cheat; then
	runOrFail "Could not install the cheat CLI." go install github.com/cheat/cheat/cmd/cheat@latest
	success "The cheat CLI installed"
else
	alreadyDone "The cheat CLI is installed"
fi
echo -e "\n"

# Install witr (https://github.com/pranshuparmar/witr)
echo "Installing witr..."
if ! isProgramInstalled witr; then
	runOrFail "Could not install witr." go install github.com/pranshuparmar/witr/cmd/witr@latest
	success "witr installed"
else
	alreadyDone "witr is installed"
fi
echo -e "\n"

# Install fx interactive JSON traversal tool (https://github.com/antonmedv/fx)
echo "Installing fx..."
if ! isProgramInstalled fx; then
	runOrFail "Could not install fx." go install github.com/antonmedv/fx@latest
	success "fx installed"
else
	alreadyDone "fx is installed"
fi
echo -e "\n"

# Install shfmt (https://github.com/mvdan/sh)
echo "Installing shfmt..."
if ! isProgramInstalled shfmt; then
	runOrFail "Could not install shfmt." go install mvdan.cc/sh/v3/cmd/shfmt@latest
	success "shfmt installed"
else
	alreadyDone "shfmt is installed"
fi
echo -e "\n"

# Install claude-code (https://code.claude.com/docs/en/overview)
echo "Installing claude code..."
if ! isProgramInstalled claude; then
	if ! curl -fsSL https://claude.ai/install.sh | bash; then
		failSetup "Could not install claude code."
	fi
	success "claude code installed"
else
	alreadyDone "claude code is installed"
fi
echo -e "\n"

# https://github.com/junegunn/fzf
echo "Installing fzf..."
if ! isProgramInstalled fzf; then
	if ! doesDirExist "$HOME/.fzf"; then
		runOrFail "Could not clone fzf." git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
	fi
	runOrFail "Could not run the fzf installer." "$HOME/.fzf/install" --all --key-bindings --completion --update-rc --no-fish --no-bash
	success "fzf installed"
else
	alreadyDone "fzf is installed"
fi
