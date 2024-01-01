#!/usr/bin/env bash

# Authenticate Github CLI
# Requirements: Github CLI

echo "Authenticating Github CLI..."

if ! isProgramInstalled gh; then
  echo "We need the Github CLI to be installed before we can authenticate you with it"
  echo "Please install the Github CLI then re-run this script. Exiting..."
  exit 1
fi

ghAuthStatus=$(gh auth status)

if [[ "$ghAuthStatus" != *"Failed"* ]]; then
  echo "Looks like you're already authenticated on Github CLI. Moving on..."
  return
fi

# From .env file
echo "$TOKEN_FOR_GITHUB_CLI" >gh_token.txt
gh auth login --with-token <gh_token.txt

unset TOKEN_FOR_GITHUB_CLI
rm gh_token.txt

echo "Checking auth status..."

gh auth status
echo "Done!"

echo -e "\nQuick Break....\c"
sleep "$SLEEP_TIME"
echo -e "Getting back to work"
