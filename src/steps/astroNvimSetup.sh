#!/usr/bin/env bash

# Setup AstroNvim

echo "Installing & setting up AstroNvim...."

nvimConfigDir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if ! isProgramInstalled git || ! isProgramInstalled nvim || ! isProgramInstalled go; then
	skipStep "git, nvim, and go are required before setting up AstroNvim."
	return
fi

if ! isDirEmpty "$nvimConfigDir"; then
	alreadyDone "$nvimConfigDir already exists; leaving existing Neovim config untouched"
	return
fi

# Install lazygit for AstroNvim (https://github.com/jesseduffield/lazygit)
echo "Installing lazygit..."
if ! isProgramInstalled lazygit; then
	runOrFail "Could not install lazygit." go install github.com/jesseduffield/lazygit@latest
	success "lazygit installed"
else
	alreadyDone "lazygit is installed"
fi
echo -e "\n"

if git ls-remote git@github.com:OlaoluwaM/nvim-setup.git &>/dev/null; then
	echo "Installing AstroNvim from our git repo (https://github.com/OlaoluwaM/nvim-setup)..."
	runOrFail "Could not clone nvim-setup into $nvimConfigDir." git clone git@github.com:OlaoluwaM/nvim-setup.git "$nvimConfigDir"
	echo -e "Updating AstroNvim dependencies...\n"
	runOrFail "Could not update AstroNvim dependencies." nvim +AstroUpdate
	success "AstroNvim dependencies updated"
	return
fi

echo "Installing AstroNvim..."
for nvimPath in "$HOME/.config/nvim" "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"; do
	if ! test -e "$nvimPath"; then
		continue
	fi

	backupPath="$nvimPath.bak"
	if test -e "$backupPath"; then
		backupPath="$nvimPath.bak.$(date +%Y%m%d%H%M%S)"
	fi

	runOrFail "Could not move $nvimPath to $backupPath." mv "$nvimPath" "$backupPath"
done

runOrFail "Could not clone the AstroNvim template into $nvimConfigDir." git clone --depth 1 https://github.com/AstroNvim/template "$nvimConfigDir"
removePath "$HOME/.config/nvim/.git"

echo "Updating AstroNvim dependencies..."
runOrFail "Could not update AstroNvim dependencies." nvim +AstroUpdate
success "AstroNvim dependencies updated"

success "AstroNvim installed and configured"
