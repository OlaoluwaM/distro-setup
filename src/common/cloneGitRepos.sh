#!/usr/bin/env bash

# Pulls down certain projects from Github
# Requirements: Active Github SSH connection, Github CLI (authenticated), Git (optional)

echo "Cloning repos from Github..."

if ! isProgramInstalled git && ! isProgramInstalled gh; then
  echo "Seems like neither git nor the Github CLI (gh) have been installed. At least one is required to clone repos from Github"
  echo "Please install and set up either git or the Github CLI before re-running this script. Exiting..."
  exit 1
fi

if isProgramInstalled gh; then
  useGit=false
else
  echo "Seems like you do not have the github cli installed. Will fallback to using regular git instead"
  useGit=true
fi

devHomePath="$HOME/Desktop/olaolu_dev"
devPath="$devHomePath/dev"

declare -A repos=(["distro-setup"]="$devPath" ["bitwarden-auto-unlock"]="$devPath" ["configs"]="$devPath" ["dev-vault"]="$devPath" ["notion-catppuccin"]="$devPath" ["coding-prob-patterns"]="$devPath" ["dotfiles"]="$devHomePath" ["haskell-from-first-principles-exercies"]="$devHomePath/learnings" ["sicp-exercises"]="$devHomePath/learnings")

for repoName in "${!repos[@]}"; do
  echo "Cloning $repoName..."
  cloneDestPath="${repos[$repoName]}/$repoName"

  # If directory exists and it is not empty
  if ! isDirEmpty "$cloneDestPath"; then
    echo "$repoName has already been cloned. Skipping to next repo..."
    continue
  fi

  if [[ $useGit == false ]]; then
    gh repo clone "OlaoluwaM/$repoName" "$cloneDestPath"
  else
    git clone "git@github.com:OlaoluwaM/${repoName}.git" "$cloneDestPath"
  fi

  # shellcheck disable=SC2181
  if [[ $? -eq 0 ]]; then
    echo "$repoName has been cloned into $cloneDestPath!"
  else
    echo "Oops, looks like something went wrong while cloning $repoName. Skipping to next repo..."
  fi
done

echo "Cloning the 'Utilities' repo...."

# The `utilities` repo is an exception and needs to be handled separately because it will be renamed when cloned
if ! isDirEmpty "$devHomePath/scripts"; then
  echo "The 'utilities' repo has already been cloned into the ${devHomePath}/scripts directory. Moving on..."
  return
fi

if [[ $useGit == false ]]; then
  gh repo clone "OlaoluwaM/utilities" "$devHomePath/scripts"
else
  git clone "git@github.com:OlaoluwaM/utilities.git" "$devHomePath/scripts"
fi

# shellcheck disable=SC2181
if [[ $? -eq 0 ]]; then
  echo "Cloning Complete!"
else
  echo "Looks like something went wrong cloning the 'utilities' repo. Please try again. Exiting..."
  exit 1
fi
