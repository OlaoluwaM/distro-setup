#!/usr/bin/env bash

# Constants
export SLEEP_TIME=2

# Utility Functions
function isProgramInstalled() {
  PROGRAM="$1"
  command -v "$PROGRAM" &>/dev/null
}

function doesDirExist() {
  TARGET_DIR="$1"
  test -d "$TARGET_DIR"
}

function doesFileExist() {
  TARGET_FILE="$1"
  test -f "$TARGET_FILE"
}

function isDirEmpty() {
  TARGET_DIR="$1"

  if doesDirExist "$TARGET_DIR" && [[ "$(ls -A "$TARGET_DIR")" ]]; then
    false
  else
    true
  fi
}

function exposeEnvValues() {
  envFile=$1

  set -o allexport
  # shellcheck source=/dev/null
  source "$envFile"
  set +o allexport
}

function startSudoRefreshLoop() {
  sudo -v
  (while true; do
    sudo -v
    sleep 50
  done) &
  SUDO_PID="$!"
  trap stopSudoRefreshLoop SIGINT SIGTERM
}

function stopSudoRefreshLoop() {
  kill "$SUDO_PID"
  trap - SIGINT SIGTERM
  sudo -k
}

function isPackageInstalled() {
  if [ $# -eq 0 ]; then
    echo "Error: No package name provided"
    return 2
  fi

  if [ "$(rpm -qa "$1" | wc -l)" -eq 0 ]; then
    return 1 # Empty output means package is not installed, so return 1
  else
    return 0 # Non-empty output means package is installed, so return 0
  fi
}

function isOutputEmpty() {
  if [ $# -eq 0 ]; then
    echo "Error: No command provided" >&2
    return 2
  fi

  local output
  output=$("$@")

  if [ -z "$output" ]; then
    echo "Output is empty"
    return 0 # Output is empty
  else
    echo "Output is not empty"
    return 1 # Output is not empty
  fi
}
