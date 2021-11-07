#!/usr/bin/env bash

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
  echo "Cloning dotfiles and white-sur gtk themes"
  if [[ $useGit == false ]]; then
    gh repo clone "OlaoluwaM/dotfiles" "$dotFilesPath/dotfiles"
    gh repo clone "vinceliuice/WhiteSur-gtk-theme" "$gnomeThemePath/WhiteSur-gtk-theme"
    gh repo clone "OlaoluwaM/dev-scripts" "$dotFilesPath/scripts"
  else
    git clone "git@github.com:OlaoluwaM/dotfiles.git" "$dotFilesPath/dotfiles"
    git clone "git@github.com:vinceliuice/WhiteSur-gtk-theme.git" "$gnomeThemePath/WhiteSur-gtk-theme"
    git clone "git@github.com:OlaoluwaM/dev-scripts.git" "$dotFilesPath/scripts"
  fi

  if [[ $? -eq 0 ]]; then
    echo "Cloning Complete"
  else
    echo "Looks like something went wrong"
    exit 1
  fi
  printf "\n"
else
  echo "Seems like neither git not the Github CLI (gh) are installed."
  exit 1
fi
printf "\n"
