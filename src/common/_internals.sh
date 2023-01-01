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

function isValidDirPathVar() {
  PATH_VAR_TO_CHECK="$1"

  if [[ -n "${PATH_VAR_TO_CHECK+x}" ]] && ! isDirEmpty "$PATH_VAR_TO_CHECK+"; then
    true
  else
    false
  fi
}
