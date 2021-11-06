#!/usr/bin/env bash

# commonScriptsDir="$(dirname "$0")"

if command -v gh &>/dev/null; then
  useGit=false
else
  echo "Seems like you do not have the github cli installed. Will use regular git instead"
  useGit=true
fi

if command -v git &>/dev/null || command -v gh &>/dev/null; then
  devPath="$HOME/Desktop/olaolu_dev/dev"
  dotFilesPath="$HOME/Desktop/olaolu_dev"
  gnomeThemePath="$HOME/customizations"

  # For dev folder repos
  echo "cloning dev repos...."
  reposInDevFolder=("distro-setup" "term-of-the-day" "surfshark-vpn-cli" "bitwarden-auto-unlock" "configs" "optIns" "optIn-custom-scripts" "cra-template-theblackuchiha")

  for repo in "${reposInDevFolder[@]}"; do
    echo "Cloning $repo..."

    if [[ $useGit == false ]]; then
      gh repo clone "OlaoluwaM/$repo" "$devPath"
    else
      git clone "git@github.com:OlaoluwaM/${repo}.git" "$devPath"
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
  echo "Cloning dotfiles and white-sur gtk themes"
  if [[ $useGit == false ]]; then
    gh repo clone "OlaoluwaM/dotfiles" "$dotFilesPath"
    gh repo clone "vinceliuice/WhiteSur-gtk-theme" "$gnomeThemePath"
  else
    git clone "git@github.com:OlaoluwaM/dotfiles.git" "$dotFilesPath"
    git clone "git@github.com:vinceliuice/WhiteSur-gtk-theme.git" "$gnomeThemePath"
  fi
  printf "\n"

  if [[ $? -eq 0 ]]; then
    echo "Cloning Complete"
  else
    echo "Looks like something went wrong"
  fi
fi
printf "\n"
