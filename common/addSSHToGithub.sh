#!/usr/bin/env bash

# Check for an existing SSH key
read -p "Enter github username: " githubuser

if (ssh -T -ai "$HOME/.ssh/id_ed25519" "git@github.com" | grep "$githubuser") &>/dev/null; then
  echo "Seems like this ssh key is already in use. Skipping step"
  return
fi

echo "Setting up SSH keys for github access"

read -p "Enter github email : " email
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

  read -s -p "Enter github password for user $githubuser: " githubpass
  echo
  read -p "Enter github OTP: " otp
  echo "Using otp $otp"
  echo

  confirm
  curl -u "$githubuser:$githubpass" -X POST -d "{\"title\":\"$(hostname)\",\"key\":\"$pub\"}" --header "x-github-otp: $otp" https://api.github.com/user/keys
fi

echo "Setup complete!"
echo "Testing connection"
ssh -T git@github.com

if [[ $? -eq 0 ]]; then
  echo "Setup works fine"
  printf "\n"
else
  echo "Uh-oh, something went wrong here. Try again?"
  exit 0
fi

# Courtesy of
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# And
# https://gist.github.com/juanique/4092969
