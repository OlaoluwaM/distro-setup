#!/usr/bin/env bash

# Set up filesystem with default directory structure

function createDirIfItDoesNotExist() {
  TARGET_DIR_PATH="$1"

  if ! doesDirExist "$TARGET_DIR_PATH"; then
    mkdir -p "$TARGET_DIR_PATH"
    echo "Done!"
  else
    echo "Directory, $TARGET_DIR_PATH, already exists"
  fi
}

function createFileIfItDoesNotExist() {
  TARGET_FILE_PATH="$1"

  if ! doesFileExist "$TARGET_FILE_PATH"; then
    touch "$TARGET_FILE_PATH"
    echo "Done!"
  else
    echo "File, $TARGET_FILE_PATH, already exists"
  fi
}

directories=(".themes" ".icons" "Desktop/olaolu_dev" "Desktop/olaolu_dev/dotfiles" "Desktop/olaolu_dev/scripts" "Desktop/olaolu_dev/learning" "Desktop/olaolu_dev/dev" "Desktop/olaolu_dev/dev/frontend-challenges" "AppImages" "Downloads/isos" ".local/share/fonts")

echo "Setting up directory structure"

for directory in "${directories[@]}"; do
  DIR="$HOME/$directory"

  echo "Creating $DIR...$(createDirIfItDoesNotExist "$DIR")"
done

echo "Directories created successfully!"
