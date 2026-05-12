#!/usr/bin/env bash

echo "Installing the GitHub CLI..."
if ! isProgramInstalled gh; then
	sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
	sudo dnf install -y gh --repo gh-cli
	gh config set git_protocol ssh --host github.com
	echo "The GitHub CLI has been installed"
else
	echo "The GitHub CLI has already been installed"
fi
