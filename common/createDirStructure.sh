#!/usr/bin/env bash

createDirIfDoesNotExist() {
  [ ! -d "$HOME/$1" ] && mkdir "$HOME/$1"
}

directories=("customizations" ".themes" "Desktop/olaolu_dev" "Desktop/olaolu_dev/dev" "Desktop/olaolu_dev/learnings" "Desktop/olaolu_dev/scripts" "AppImages" "Downloads/rpms" "Downloads/others")

echo "Creating directories"

for directory in "${directories[@]}"; do
  createDirIfDoesNotExist "$directory"
  echo "$HOME/$directory created"
done

echo "Directories created successfully"
