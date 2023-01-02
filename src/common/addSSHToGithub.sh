#!/usr/bin/env bash

# Sets up SSH connection with Github
# Requirements: git or the GitHub CLI, GH CLI must be authenticated, curl (optional)

echo "Setting up SSH keys for github access..."

if ! isProgramInstalled git && ! isProgramInstalled gh; then
  echo "Seems like neither git nor the Github CLI (gh) are installed. Both are required to set up SSH access to GitHub"
  echo "Please install and set up either one then re-run this script. Exiting..."
  exit 1
fi

# Check for an existing SSH connection
# With the GitHub check, a successful response will exit with an exit code of 1
if [[ $(
  ssh -T git@github.com &>/dev/null
  echo $?
) -eq 1 ]]; then
  echo "Seems like your already have a working ssh connection to Github :D. Moving on..."
  return
fi

title="${1:-'Personal Laptop (Linux)'}"

# Apparently, ZSH has a different `read` syntax from bash
githubuser=$(bash -c 'read -p "Enter github username: " githubuser; echo $githubuser')
email=$(bash -c 'read -p "Enter github email: " email; echo $email')

echo "Using email $email"

if ! doesFileExist "$HOME/.ssh/id_ed25519"; then
  ssh-keygen -t ed25519 -b 4096 -C "$email"
  ssh-add ~/.ssh/id_ed25519
fi

pub=$(cat ~/.ssh/id_ed25519.pub)

if isProgramInstalled gh; then
  echo "Using Github CLI to add ssh keys..."
  gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "$title"
  echo "Done"
else
  echo "Can't use the Github CLI to add ssh keys. Falling back to git..."

  if ! isProgramInstalled curl; then
    echo "You need to install curl to setup your ssh keys with git"
    echo "Please install curl then re-run this script. Exiting..."
    exit 1
  fi

  githubpass=$(bash -c 'read -sp "Enter github password for user "$0": " githubpass; echo $githubpass' "$githubuser")

  otp=$(bash -c 'read -sp "Enter github OTP ": " otp; echo $otp')
  echo "Using otp $otp"

  confirm
  curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"$(hostname)\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
fi

echo -e "\nSetup complete!"
echo "Testing connection..."

if [[ $(
  ssh -T git@github.com
  echo $?
) -eq 1 ]]; then
  echo -e "\nSuccess! SSH connection established"
else
  echo -e "\nUh-oh, looks like something may have gone wrong. Exiting..."
  exit 1
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
