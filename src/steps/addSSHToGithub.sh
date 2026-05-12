#!/usr/bin/env bash

# Sets up SSH connection with Github
# Requirements: git, authenticated GitHub CLI

echo "Setting up SSH keys for github access..."

if ! isProgramInstalled git || ! isProgramInstalled gh; then
	echo "Git and the GitHub CLI are required to set up SSH access to GitHub."
	skipStep "Please install and set up both, then re-run this script."
	return
fi

# Check for an existing SSH connection
# With the GitHub check, a successful response will exit with an exit code of 1
if isGithubSshReady; then
	alreadyDone "SSH connection to GitHub works"
	return
fi

title="${1:-'Personal Laptop (Linux)'}"
sshPrivateKey="$HOME/.ssh/id_ed25519"
sshPublicKey="$sshPrivateKey.pub"

runOrFail "Could not create $HOME/.ssh." mkdir -p "$HOME/.ssh"

if ! doesFileExist "$sshPrivateKey"; then
	runOrFail "Could not generate SSH key at $sshPrivateKey." ssh-keygen -t ed25519 -b 4096 -C "$title" -N "" -f "$sshPrivateKey"
fi

if ! doesFileExist "$sshPublicKey"; then
	if ! ssh-keygen -y -f "$sshPrivateKey" >"$sshPublicKey"; then
		failSetup "Could not create public key at $sshPublicKey."
	fi
fi

runOrWarn "Could not add $sshPrivateKey to ssh-agent." ssh-add "$sshPrivateKey"

publicKey="$(<"$sshPublicKey")"

if gh api user/keys --jq '.[].key' | grep -Fx "$publicKey" &>/dev/null; then
	alreadyDone "SSH public key is registered with GitHub"
else
	echo "Using GitHub CLI to add ssh key..."
	runOrFail "Could not add SSH key to GitHub." gh ssh-key add "$sshPublicKey" --title "$title"
	success "SSH key added to GitHub"
fi

echo -e "\nSSH key setup complete."
echo "Testing connection..."

if isGithubSshReady; then
	echo -e "\n"
	success "SSH connection established"
else
	failSetup "SSH connection test failed."
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
