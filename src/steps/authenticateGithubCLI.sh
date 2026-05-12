#!/usr/bin/env bash

# Authenticate Github CLI
# Requirements: Github CLI

echo "Authenticating Github CLI..."

if ! isProgramInstalled gh; then
	echo "We need the Github CLI to be installed before we can authenticate you with it"
	skipStep "Please install the Github CLI, then re-run this script."
	return
fi

# This is the first check so don't output anything to the console
if gh auth status &>/dev/null; then
	alreadyDone "GitHub CLI is authenticated"
	return
fi

if [[ -z "${TOKEN_FOR_GITHUB_CLI+x}" ]]; then
	failSetup "The TOKEN_FOR_GITHUB_CLI environment variable is not set. Please set it then re-run this script."
fi

# From .env file
if ! printf '%s\n' "$TOKEN_FOR_GITHUB_CLI" | gh auth login --with-token; then
	failSetup "Could not authenticate with GitHub CLI using TOKEN_FOR_GITHUB_CLI."
fi

unset TOKEN_FOR_GITHUB_CLI

echo "Checking auth status..."

if gh auth status; then
	success "Authentication with Github CLI completed"

	echo -e "\nQuick Break....\c"
	sleep "$SLEEP_TIME"
	echo -e "Getting back to work"
else
	failSetup "Something went wrong while attempting to authenticate you with Github CLI."
fi
