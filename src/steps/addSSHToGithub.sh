#!/usr/bin/env bash

# Sets up SSH connection with Github
# Requirements: git, authenticated GitHub CLI

echo "Setting up SSH keys for github access..."

if ! isProgramInstalled git || ! isProgramInstalled gh; then
	echo "Git and the GitHub CLI are required to set up SSH access to GitHub."
	echo "Please install and set up both, then re-run this script."
	return
fi

# Check for an existing SSH connection
# With the GitHub check, a successful response will exit with an exit code of 1
if isGithubSshReady; then
	echo "Seems like your already have a working ssh connection to Github :D. Moving on..."
	return
fi

title="${1:-'Personal Laptop (Linux)'}"

if ! doesFileExist "$HOME/.ssh/id_ed25519"; then
	ssh-keygen -t ed25519 -b 4096 -C "$title"
	ssh-add ~/.ssh/id_ed25519
fi

echo "Using GitHub CLI to add ssh keys..."
gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title"
echo "Done"

echo -e "\nSetup complete!"
echo "Testing connection..."

if isGithubSshReady; then
	echo -e "\nSuccess! SSH connection established"
else
	failSetup "SSH connection test failed."
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
