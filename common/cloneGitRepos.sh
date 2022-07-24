#!/usr/bin/env bash

# Depends on Github CLI or Git
# Requires you to be authenticated with an ssh connection to github

if command -v gh &>/dev/null; then
  useGit=false
else
  echo "Seems like you do not have the github cli installed. Will use regular git instead"
  useGit=true
fi

if command -v git &>/dev/null || command -v gh &>/dev/null; then
  devPath="$HOME/Desktop/olaolu_dev/dev"
  dotFilesPath="$HOME/Desktop/olaolu_dev"

  # For dev folder repos
  echo "cloning dev repos...."
  reposInDevFolder=("distro-setup" "term-of-the-day" "surfshark-vpn-cli" "bitwarden-auto-unlock" "configs" "scaffy" "dotfilers")

  for repo in "${reposInDevFolder[@]}"; do
    echo "Cloning $repo..."

    if [ -d "$devPath/$repo" ]; then
      echo "Oh, it looks like $repo has already been cloned, skipping..."
      printf "\n"
      continue
    fi

    if [[ $useGit == false ]]; then
      gh repo clone "OlaoluwaM/$repo" "$devPath/$repo"
    else
      git clone "git@github.com:OlaoluwaM/${repo}.git" "$devPath/$repo"
    fi

    if [[ $? -eq 0 ]]; then
      echo "$repo cloned! into $devPath/$repo"

    else
      echo "Oops, looks like something went wrong cloning $repo"
      echo "Skipping...."
    fi
    printf "\n"
  done

  printf "\n"

  # For other repos
  echo "Cloning dotfiles and Other Scripts"
  if [[ $useGit == false ]]; then
    if [ ! -d "$dotFilesPath/dotfiles" ]; then
      gh repo clone "OlaoluwaM/dotfiles" "$dotFilesPath/dotfiles"
    else
      echo "dotfiles already cloned"
    fi
    printf "\n"

    if [ ! -d "$dotFilesPath/scripts" ]; then
      gh repo clone "OlaoluwaM/dev-scripts" "$dotFilesPath/scripts"
    else
      echo "scripts already cloned"
    fi
    printf "\n"

  else
    if [ ! -d "$dotFilesPath/dotfiles" ]; then
      git clone "git@github.com:OlaoluwaM/dotfiles.git" "$dotFilesPath/dotfiles"
    else
      echo "dotfiles already cloned"
    fi
    printf "\n"

    if [ ! -d "$dotFilesPath/scripts" ]; then
      git clone "git@github.com:OlaoluwaM/dev-scripts.git" "$dotFilesPath/scripts"
    else
      echo "scripts already cloned"
    fi
  fi

  if [[ $? -eq 0 ]]; then
    echo "Cloning Complete"
  else
    echo "Looks like something went wrong"
    exit 1
  fi

else
  echo "Seems like neither git not the Github CLI (gh) are installed."
  exit 1
fi
printf "\n"
