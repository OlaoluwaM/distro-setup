#!/usr/bin/env bash

# Pulls down certain projects from Github
# Requirements: Active Github SSH connection, Github CLI (authenticated), Git (optional)

echo "Cloning repos from Github..."

if ! isProgramInstalled git && ! isProgramInstalled gh; then
	echo "Seems like neither git nor the Github CLI (gh) have been installed. At least one is required to clone repos from Github"
	skipStep "Please install and set up either git or the Github CLI before re-running this script."
	return
fi

if isProgramInstalled gh; then
	useGit=false
else
	echo "Seems like you do not have the github cli installed. Will fallback to using regular git instead"
	useGit=true
fi

repoList="$SETUP_ASSETS_DIR/repos.tsv"

if ! doesFileExist "$repoList"; then
	echo "Cannot find repo list at $repoList"
	return
fi

failedCloneCount=0

while IFS=$'\t' read -r repoName cloneBasePath; do
	[[ -z "$repoName" || "$repoName" == \#* ]] && continue

	cloneBasePath="${cloneBasePath/#\$HOME/$HOME}"
	cloneDestPath="$cloneBasePath/$repoName"
	runOrFail "Could not create clone base path $cloneBasePath." mkdir -p "$cloneBasePath"

	# If directory exists and it is not empty
	if ! isDirEmpty "$cloneDestPath"; then
		alreadyDone "$repoName has already been cloned"
		echo -e "\n"
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
		warn "Something went wrong while cloning $repoName."
		((failedCloneCount++))
	fi

	echo -e "\n"
done <"$repoList"

if [[ $failedCloneCount -gt 0 ]]; then
	failSetup "$failedCloneCount repository clone(s) failed."
fi

success "Repositories cloned"
