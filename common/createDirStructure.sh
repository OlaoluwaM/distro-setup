#!/usr/bin/env bash

desiredRoot="/home/$(whoami)"

createDirIfDoesNotExist() {
  [ ! -d "$desiredRoot/$1" ] && mkdir "$desiredRoot/$1"
}

directories=("customizations" ".themes" "Desktop/olaolu_dev" "Desktop/olaolu_dev/dev" "Desktop/olaolu_dev/learnings" "Desktop/olaolu_dev/scripts" "AppImages" "Downloads/rpms" "Downloads/others")

echo "Creating directories"

for directory in "${directories[@]}"; do
  createDirIfDoesNotExist "$directory"
  echo "$desiredRoot/$directory created"
done

echo "Directories created successfully"
