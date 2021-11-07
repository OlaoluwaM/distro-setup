#!/usr/bin/env bash

# Depends on Github CLI
# Github CLI must be authenticated with valid PAT

# Check for an existing SSH connection
if [[ $(
  ssh -T git@github.com
  echo $?
) -eq 1 ]]; then
  echo "Seems like your already have a working ssh connection :D"
  printf "\n"
  return
fi

# Apparently, ZSH has a different `read` syntax from bash
githubuser=$(bash -c 'read -p "Enter github username: " githubuser; echo $githubuser')
echo "Setting up SSH keys for github access"

email=$(bash -c 'read -p "Enter github email: " email; echo $email')

echo "Using email $email"
printf "\n"

if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -b 4096 -C "$email"
  ssh-add ~/.ssh/id_ed25519
fi

pub=$(cat ~/.ssh/id_ed25519.pub)

if command -v gh &>/dev/null; then
  echo "Using Github CLI to add ssh keys..."
  gh ssh-key add "$HOME/.ssh/id_ed25519.pub" --title "personal laptop (fedora)"
  echo "Done"
else
  echo "Using username $githubuser"
  printf "\n"

  githubpass=$(bash -c 'read -sp "Enter github password for user "$0": " githubpass; echo $githubpass' "$githubuser")
  echo
  otp=$(bash -c 'read -sp "Enter github OTP ": " otp; echo $otp')
  echo "Using otp $otp"
  echo

  confirm
  curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"$(hostname)\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
fi

echo "Setup complete!"
echo "Testing connection"
ssh -T git@github.com

if [[ $(
  ssh -T git@github.com &>/dev/null
  echo $?
) -eq 1 ]]; then
  echo "Great! connection works"
  printf "\n"
else
  echo "Uh-oh, something went wrong. Try again?"
  exit 1
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
