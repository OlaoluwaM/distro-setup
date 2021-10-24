#!/usr/bin/env bash

isNotInstalled() {
  if [ "$(
    $1 &>/dev/null
    echo $?
  )" -gt 0 ]; then
    echo true
  else
    echo false
  fi
}

isInstalled() {
  if [ "$(
    $1 &>/dev/null
    echo $?
  )" -eq 0 ]; then
    echo true
  else
    echo false
  fi
}
