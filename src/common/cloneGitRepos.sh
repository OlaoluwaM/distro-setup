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

labsHomePath="$HOME/Desktop"
labsPath="$labsHomePath/labs"

declare -A repos=(["distro-setup"]="$labsPath" ["snippets"]="$labsPath" ["dotfiles"]="$labsHomePath" ["haskell-from-first-principles-exercies"]="$labsPath" ["sicp-exercises"]="$labsPath" ["advent-of-code"]="$labsPath" ["redis-haskell"]="$labsPath")

for repoName in "${!repos[@]}"; do
  cloneDestPath="${repos[$repoName]}/$repoName"

  # If directory exists and it is not empty
  if ! isDirEmpty "$cloneDestPath"; then
    echo -e "$repoName has already been cloned. Skipping to next repo...\n"
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

  echo -e "\n"
done

echo -e "\nCloning complete!"
