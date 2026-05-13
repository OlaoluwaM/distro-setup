#!/usr/bin/env bash

# Setup-time environment defaults. These values make the bootstrap scripts
# deterministic without depending on an interactive shell startup file.

function setupEnvDefaults() {
	export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
	export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
	export CUSTOM_BIN_DIR="${CUSTOM_BIN_DIR:-$HOME/.local/bin}"
	export DEV="$HOME/Desktop/dev"

	export DOTS="${DOTS:-$HOME/Desktop/dotfiles/boreas/fedora}"
	export DOTS_DIR="$DOTS"

	export NVM_DIR="${NVM_DIR:-$XDG_CONFIG_HOME/nvm}"
	export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"
}

function addToPath() {
	local pathEntry="$1"

	case ":$PATH:" in
	*":$pathEntry:"*) ;;
	*) export PATH="$pathEntry:$PATH" ;;
	esac
}

function setupEnvPath() {
	addToPath "$CUSTOM_BIN_DIR"
	addToPath "$PNPM_HOME"
	addToPath "$PNPM_HOME/bin"
}

function setupEnv() {
	setupEnvDefaults
	setupEnvPath
}

setupEnv
