#!/usr/bin/env bash

# Install extensions for the Github CLI
# Requirements: The Github CLI, dotfiles

echo "Installing extensions for the Github CLI..."

if ! isProgramInstalled gh; then
	echo "We need the Github CLI to be installed before we can install any extensions"
	skipStep "Please install it, then re-run this script."
	return
fi

if ! isGithubSshReady; then
	echo "You'll need a valid SSH connection to GitHub before we can install any extensions for the CLI"
	skipStep "Please set this up, then re-run this script."
	return
fi

# Should be run after shell aliases are set
GH_EXT_LIST="$DOTS_DIR/gh/gh-extensions.txt"

if ! doesFileExist "$GH_EXT_LIST"; then
	echo "The file containing the list of CLI extensions to install cannot be found. The path to the file ($GH_EXT_LIST) might not exist"
	skipStep "Please create and populate this file, then re-run this script."
	return
fi

function isGhExtensionInstalled() {
	local extensionName="$1"

	gh extension list | grep -F "$extensionName" &>/dev/null
}

function allGhExtensionsInstalled() {
	local extensionName

	while read -r extensionName; do
		[[ -z "$extensionName" || "$extensionName" == \#* ]] && continue

		if ! isGhExtensionInstalled "$extensionName"; then
			return 1
		fi
	done <"$GH_EXT_LIST"
}

if allGhExtensionsInstalled; then
	alreadyDone "GitHub CLI extensions are installed"
	return
fi

failedExtensionCount=0

while read -r extensionName; do
	[[ -z "$extensionName" || "$extensionName" == \#* ]] && continue

	if ! isGhExtensionInstalled "$extensionName"; then
		if gh extension install "$extensionName"; then
			success "$extensionName installed"
		else
			warn "Could not install $extensionName"
			((failedExtensionCount++))
		fi
	else
		alreadyDone "$extensionName is installed"
	fi

	echo -e "\n"
done <"$GH_EXT_LIST"

if [[ $failedExtensionCount -gt 0 ]]; then
	failSetup "$failedExtensionCount GitHub CLI extension install(s) failed."
fi

success "GitHub CLI extensions installed"
