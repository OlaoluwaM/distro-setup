#!/usr/bin/env bash

if ! doesDirExist "$LOCAL_RPMS_DIR"; then
  echo "Local rpms directory does not exist"
  echo "You might need to restore your Deja Dup backup. Skipping installation..."
  return
fi

LOCAL_RPMS_DIR="$HOME/Downloads/rpms/"
echo "Installing local rpms..."

# Do not quote
LOCAL_RPMS=($HOME/Downloads/rpms/*)
sudo dnf install "${LOCAL_RPMS[@]}" -y
