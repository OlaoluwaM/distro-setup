#!/usr/bin/env bash

createDirIfDoesNotExist() {
  [ ! -d "$HOME/$1" ] && mkdir "$HOME/$1" || echo "directory $HOME/$1 already exists"
}

createFileIfDoesNotExist() {
  [ ! -f "$HOME/$1" ] && touch "$HOME/$1" || echo "file $HOME/$1 already exists"
}

directories=("customizations" ".themes" "Desktop/olaolu_dev" "Desktop/olaolu_dev/dev" "Desktop/olaolu_dev/learnings" "Desktop/olaolu_dev/scripts" "AppImages" "Downloads/rpms" "Downloads/others" "Desktop/olaolu_dev/dev/frontend-challenges" "Desktop/olaolu_dev/dev/frontend-challenges/in-progress")

echo "Creating directories"

for directory in "${directories[@]}"; do
  createDirIfDoesNotExist "$directory"
done

echo "Directories created successfully"
printf "\n"

createFileIfDoesNotExist ".personal_tokens"
printf "\n"
