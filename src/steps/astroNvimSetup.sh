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

echo "Installing AstroNvim from our git repo (https://github.com/OlaoluwaM/nvim-setup)..."
runOrFail "Could not clone nvim-setup into $nvimConfigDir." git clone git@github.com:OlaoluwaM/nvim-setup.git "$nvimConfigDir"

echo "Updating AstroNvim dependencies..."
runOrFail "Could not update AstroNvim dependencies." nvim +AstroUpdate
success "AstroNvim dependencies updated"

success "AstroNvim installed and configured"
