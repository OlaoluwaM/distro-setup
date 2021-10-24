#!/usr/bin/env bash

exposeEnvValues() {
  envFile=$1
  set -o allexport
  . "$envFile"
  set +o allexport
}
