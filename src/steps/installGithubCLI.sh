#!/usr/bin/env bash

echo "Installing the GitHub CLI..."
if ! isProgramInstalled gh; then
	runOrFail "Could not add the GitHub CLI repository." sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
	runOrFail "Could not install the GitHub CLI." sudo dnf install -y gh --repo gh-cli
	runOrFail "Could not configure the GitHub CLI git protocol." gh config set git_protocol ssh --host github.com
	success "The GitHub CLI installed"
else
	alreadyDone "The GitHub CLI is installed"
fi
