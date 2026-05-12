#!/usr/bin/env bash

# Install and setup Oh My Zsh

echo "Installing Oh-My-Zsh..."

if ! isProgramInstalled curl; then
	echo "We need curl to install Oh My Zsh"
	skipStep "Please install curl, then re-run this script."
	return
fi

OMZ_DIR="$HOME/.oh-my-zsh"

if ! isDirEmpty "$OMZ_DIR"; then
	alreadyDone "Oh My Zsh is installed"
	return
fi

omzInstallScript="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
if [[ -z "$omzInstallScript" ]]; then
	failSetup "Could not download the Oh My Zsh installer."
fi

if ! sh -c "$omzInstallScript" "" --keep-zshrc; then
	failSetup "Could not install Oh My Zsh."
fi
success "Oh My Zsh installed"
pauseForRerun "Oh My Zsh was installed and shell startup files may need to reload."
