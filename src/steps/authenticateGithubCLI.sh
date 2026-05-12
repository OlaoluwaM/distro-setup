#!/usr/bin/env bash

# Authenticate Github CLI
# Requirements: Github CLI

echo "Authenticating Github CLI..."

if ! isProgramInstalled gh; then
	echo "We need the Github CLI to be installed before we can authenticate you with it"
	echo "Please install the Github CLI then re-run this script."
	return
fi

# This is the first check so don't output anything to the console
if gh auth status &>/dev/null; then
	echo "Looks like you're already authenticated on Github CLI. Moving on..."
	return
fi

if [[ -z "${TOKEN_FOR_GITHUB_CLI+x}" ]]; then
	failSetup "The TOKEN_FOR_GITHUB_CLI environment variable is not set. Please set it then re-run this script."
fi

# From .env file
printf '%s\n' "$TOKEN_FOR_GITHUB_CLI" | gh auth login --with-token

unset TOKEN_FOR_GITHUB_CLI

echo "Checking auth status..."

if gh auth status; then
	echo "Success!"
	echo "Authentication with Github CLI has been completed"

	echo -e "\nQuick Break....\c"
	sleep "$SLEEP_TIME"
	echo -e "Getting back to work"
else
	failSetup "Something went wrong while attempting to authenticate you with Github CLI."
fi
