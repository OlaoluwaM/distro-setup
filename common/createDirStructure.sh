#!/usr/bin/env bash

createDirIfDoesNotExist() {
  [ ! -d "$HOME/$1" ] && mkdir "$HOME/$1" || echo "directory $HOME/$1 already exists"
}

createFileIfDoesNotExist() {
  [ ! -f "$HOME/$1" ] && touch "$HOME/$1" || echo "file $HOME/$1 already exists"
}

directories=("customizations" ".themes" ".icons" "Desktop/olaolu_dev" "Desktop/olaolu_dev/dev" "AppImages" "Desktop/olaolu_dev/dev/frontend-challenges" "Desktop/olaolu_dev/dev/frontend-challenges/in-progress" "Downloads/isos" ".local/share/fonts")

echo "Creating directories"

for directory in "${directories[@]}"; do
  echo "Creating $HOME/$directory"
  createDirIfDoesNotExist "$directory"
  echo -e "Done\n"
done

echo "Directories created successfully"
printf "\n"

createFileIfDoesNotExist ".personal_tokens"
printf "\n"
