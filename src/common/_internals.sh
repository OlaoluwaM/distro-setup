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
  trap stopsudo SIGINT SIGTERM
}

function stopSudoRefreshLoop() {
  kill "$SUDO_PID"
  trap - SIGINT SIGTERM
  sudo -k
}
