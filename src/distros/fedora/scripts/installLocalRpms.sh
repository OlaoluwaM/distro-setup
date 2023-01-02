#!/usr/bin/env bash

LOCAL_RPMS_DIR="$HOME/Downloads/rpms/"

echo "Installing local rpms..."

if [ ! -d "$LOCAL_RPMS_DIR" ]; then
  echo "local rpms directory does not exist...aborting"
  exit 1
fi

# Do not quote
LOCAL_RPMS=($HOME/Downloads/rpms/*)
sudo rpm -iv "${LOCAL_RPMS[@]}"
