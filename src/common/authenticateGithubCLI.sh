#!/usr/bin/env bash

# Authenticate Github CLI
# Requirements: Github CLI

echo "Authenticating Github CLI..."

if ! isProgramInstalled gh; then
  echo "We need the Github CLI to be installed before we can authenticate you with it"
  echo "Please install the Github CLI then re-run this script. Exiting..."
  exit 1
fi

# This is the first check so don't output anything to the console
if gh auth status &>/dev/null; then
  echo "Looks like you're already authenticated on Github CLI. Moving on..."
  return
fi

if [[ -z "${TOKEN_FOR_GITHUB_CLI+x}" ]]; then
  echo "The TOKEN_FOR_GITHUB_CLI environment variable is not set. Please set it then re-run this script. Exiting..."
  exit 1
fi

# From .env file
echo "$TOKEN_FOR_GITHUB_CLI" >gh_token.txt
gh auth login --with-token <gh_token.txt

unset TOKEN_FOR_GITHUB_CLI
rm gh_token.txt

echo "Checking auth status..."

if gh auth status; then
  echo "Success!"
  echo "Authentication with Github CLI has been completed"

  echo -e "\nQuick Break....\c"
  sleep "$SLEEP_TIME"
  echo -e "Getting back to work"
else
  echo "Something went wrong while attempting to authenticate you with Github CLI. Exiting..."
  exit 1
fi
