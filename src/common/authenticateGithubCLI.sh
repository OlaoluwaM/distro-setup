#!/usr/bin/env bash

# Authenticate Github CLI
# Requirements: Github CLI

if gh auth status &>/dev/null; then
  echo "Already authenticated on Github CLI"
  return
fi

echo "Authenticating Github CLI..."

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
echo -e "Getting back to work\n"
