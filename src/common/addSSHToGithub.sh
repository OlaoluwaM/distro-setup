#!/usr/bin/env bash

# Sets up SSH connection with Github
# Requirements: git or the GitHub CLI, GH CLI must be authenticated, curl (optional)

if ! isProgramInstalled git && ! isProgramInstalled gh; then
  echo "Seems like neither git nor the Github CLI (gh) are installed. Both are required to run this script."
  echo "Please install and set up either one before trying again. Exiting..."
  exit 1
fi

# Check for an existing SSH connection
# With the GitHub check, a successful response will exit with an exit code of 1
if ! ssh -T git@github.com &>/dev/null; then
  echo "Seems like your already have a working ssh connection :D"
  return
fi

title="${1:-'Personal Laptop (Linux)'}"

echo "Setting up SSH keys for github access"

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
  echo "Can't use the Github CLI to add ssh keys, faling back to git with username $githubuser"

  if ! isProgramInstalled curl; then
    echo "You need to install curl to setup your ssh keys with git"
    exit 1
  fi

  githubpass=$(bash -c 'read -sp "Enter github password for user "$0": " githubpass; echo $githubpass' "$githubuser")

  otp=$(bash -c 'read -sp "Enter github OTP ": " otp; echo $otp')
  echo "Using otp $otp"

  confirm
  curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"$(hostname)\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
fi

echo "Setup complete!"
echo "Testing connection...\c"

if ! ssh -T git@github.com &>/dev/null; then
  echo "Seems like your already have a working ssh connection :D"
else
  echo "Uh-oh, something went wrong. Try again?"
  exit 1
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
