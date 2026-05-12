#!/usr/bin/env bash

# Set up filesystem with default directory structure

function createDirIfItDoesNotExist() {
	TARGET_DIR_PATH="$1"

	if ! doesDirExist "$TARGET_DIR_PATH"; then
		runOrFail "Could not create directory $TARGET_DIR_PATH." mkdir -p "$TARGET_DIR_PATH"
		success "$TARGET_DIR_PATH created"
	else
		alreadyDone "$TARGET_DIR_PATH exists"
	fi
}

function createFileIfItDoesNotExist() {
	TARGET_FILE_PATH="$1"

	if ! doesFileExist "$TARGET_FILE_PATH"; then
		runOrFail "Could not create file $TARGET_FILE_PATH." touch "$TARGET_FILE_PATH"
		success "$TARGET_FILE_PATH created"
	else
		alreadyDone "$TARGET_FILE_PATH exists"
	fi
}

directoriesFile="$SETUP_ASSETS_DIR/directories.txt"

if ! doesFileExist "$directoriesFile"; then
	echo "Cannot find directory list at $directoriesFile"
	return
fi

echo "Setting up directory structure"

while IFS= read -r directory; do
	[[ -z "$directory" || "$directory" == \#* ]] && continue

	DIR="$HOME/$directory"

	echo "Creating $DIR..."
	createDirIfItDoesNotExist "$DIR"
done <"$directoriesFile"

success "Directory structure is present"
echo -e "\n"

# https://bbs.archlinux.org/viewtopic.php?id=183420
echo "Creating symbolic links for XDG dirs..."

if ! doesDirExist "$HOME/.icons"; then
	echo "Creating $HOME/.icons through symlink to $HOME/.local/share/icons..."
	runOrFail "Could not create $HOME/.icons symlink." ln -svf "$HOME/.local/share/icons" "$HOME/.icons"
	success "$HOME/.icons symlink created"
	echo -e "\n"
else
	alreadyDone "$HOME/.icons exists"
	echo -e "\n"
fi

if ! doesDirExist "$HOME/.themes"; then
	echo "Creating $HOME/.themes through symlink to $HOME/.local/share/themes..."
	runOrFail "Could not create $HOME/.themes symlink." ln -svf "$HOME/.local/share/themes" "$HOME/.themes"
	success "$HOME/.themes symlink created"
	echo -e "\n"
else
	alreadyDone "$HOME/.themes exists"
	echo -e "\n"
fi

if ! doesDirExist "$HOME/.fonts"; then
	echo "Creating $HOME/.fonts through symlink to $HOME/.local/share/fonts..."
	runOrFail "Could not create $HOME/.fonts symlink." ln -svf "$HOME/.local/share/fonts" "$HOME/.fonts"
	success "$HOME/.fonts symlink created"
	echo -e "\n"
else
	alreadyDone "$HOME/.fonts exists"
	echo -e "\n"
fi

success "Filesystem setup complete"
