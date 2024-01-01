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

directories=("Desktop/labs" "Desktop/serokell" "AppImages" "Downloads/isos" ".local/share/icons" ".local/share/fonts" ".local/share/themes")

echo "Setting up directory structure"

for directory in "${directories[@]}"; do
  DIR="$HOME/$directory"

  echo "Creating $DIR...$(createDirIfItDoesNotExist "$DIR")"
done

echo -e "Directories created successfully!\n"

# https://bbs.archlinux.org/viewtopic.php?id=183420
echo "Creating symbolic links for XDG dirs..."

if ! doesDirExist "$HOME/.icons"; then
  echo "Creating $HOME/.icons through symlink to $HOME/.local/share/icons..."
  ln -svf "$HOME/.local/share/icons" "$HOME/.icons"
  echo -e "Done!\n"
else
  echo -e "Looks like $HOME/.icons already exists. Skipping...\n"
fi

if ! doesDirExist "$HOME/.themes"; then
  echo "Creating $HOME/.themes through symlink to $HOME/.local/share/themes..."
  ln -svf "$HOME/.local/share/themes" "$HOME/.themes"
  echo -e "Done!\n"
else
  echo -e "Looks like $HOME/.themes already exists. Skipping...\n"
fi

echo "FS Setup Complete!"
