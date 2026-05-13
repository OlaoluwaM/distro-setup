#!/usr/bin/env bash

set -o pipefail

export SLEEP_TIME="${SLEEP_TIME:-2}"
export SETUP_ROOT_DIR="${SETUP_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export SETUP_STEPS_DIR="${SETUP_STEPS_DIR:-$SETUP_ROOT_DIR/steps}"
export SETUP_ASSETS_DIR="${SETUP_ASSETS_DIR:-$SETUP_ROOT_DIR/assets}"
export DOTS_DIR="${DOTS_DIR:-$HOME/Desktop/dotfiles/fedora/.config}"

function info() {
	echo "$*"
}

function warn() {
	echo "Warning: $*" >&2
}

function success() {
	echo "Done: $*"
}

function alreadyDone() {
	echo "Already done: $*"
}

function failSetup() {
	echo "Error: $*" >&2
	exit 1
}

function skipStep() {
	echo "Skipping: $*"
}

function runOrFail() {
	local failureMessage="$1"
	shift

	if ! "$@"; then
		failSetup "$failureMessage"
	fi
}

function runOrWarn() {
	local warningMessage="$1"
	shift

	if ! "$@"; then
		warn "$warningMessage"
		return 1
	fi
}

function pauseForRerun() {
	echo "$*"
	echo "Re-run this setup after completing the requested action."
	exit 0
}

function quickBreak() {
	echo -e "Quick Break...\c"
	sleep "$SLEEP_TIME"
	echo -e "Getting back to work\n"
}

function runStep() {
	local stepName="$1"
	local stepPath="$2"
	shift 2

	echo "==> $stepName"

	if ! doesFileExist "$stepPath"; then
		failSetup "Cannot find setup step at $stepPath"
	fi

	# shellcheck source=/dev/null
	. "$stepPath" "$@"
	local status=$?

	if [[ $status -ne 0 ]]; then
		failSetup "$stepName failed with exit code $status"
	fi

	echo -e "\n"
}

function requireProgram() {
	local program="$1"
	local message="${2:-$program is required for this step.}"

	if ! isProgramInstalled "$program"; then
		echo "$message"
		return 1
	fi
}

function requireFile() {
	local filePath="$1"
	local message="${2:-Required file not found: $filePath}"

	if ! doesFileExist "$filePath"; then
		echo "$message"
		return 1
	fi
}

function requireDir() {
	local dirPath="$1"
	local message="${2:-Required directory not found: $dirPath}"

	if ! doesDirExist "$dirPath"; then
		echo "$message"
		return 1
	fi
}

function requireEnv() {
	local envName="$1"
	local message="${2:-Required environment variable is not set: $envName}"

	if [[ -z "${!envName+x}" ]]; then
		echo "$message"
		return 1
	fi
}

# Utility Functions
function isProgramInstalled() {
	local PROGRAM="$1"
	command -v "$PROGRAM" &>/dev/null
}

function doesDirExist() {
	local TARGET_DIR="$1"
	test -d "$TARGET_DIR"
}

function doesFileExist() {
	local TARGET_FILE="$1"
	test -f "$TARGET_FILE"
}

function isDirEmpty() {
	local TARGET_DIR="$1"

	if doesDirExist "$TARGET_DIR" && [[ "$(ls -A "$TARGET_DIR")" ]]; then
		false
	else
		true
	fi
}

function exposeEnvValues() {
	local envFile="$1"

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
	trap stopSudoRefreshLoop EXIT SIGINT SIGTERM
}

function stopSudoRefreshLoop() {
	if [[ -n "${SUDO_PID:-}" ]]; then
		kill "$SUDO_PID" 2>/dev/null || true
		unset SUDO_PID
	fi
	trap - EXIT SIGINT SIGTERM
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

function hasGpuVendor() {
	local vendorId="$1"
	local device
	local vendor
	local class
	local pciVendorId

	for device in /sys/bus/pci/devices/*; do
		[[ -r "$device/vendor" && -r "$device/class" ]] || continue

		vendor="$(<"$device/vendor")"
		class="$(<"$device/class")"

		if [[ "$vendor" == "$vendorId" && "$class" == 0x03* ]]; then
			return 0
		fi
	done

	if isProgramInstalled lspci; then
		pciVendorId="${vendorId#0x}"

		while read -r _ class vendor _; do
			class="${class//\"/}"
			vendor="${vendor//\"/}"

			if [[ "$vendor" == "$pciVendorId" && "$class" == 03* ]]; then
				return 0
			fi
		done < <(lspci -Dnmm)
	fi

	return 1
}

function hasIntelGpu() {
	hasGpuVendor 0x8086
}

function hasNvidiaGpu() {
	hasGpuVendor 0x10de
}

function hasAmdGpu() {
	hasGpuVendor 0x1002
}

function isGithubSshReady() {
	ssh -T git@github.com &>/dev/null
	[[ $? -eq 1 ]]
}

function dnfInstallIfPackageMissing() {
	local packageName="$1"

	if isPackageInstalled "$packageName"; then
		echo "$packageName has already been installed"
		return
	fi

	sudo dnf install -y "$packageName"
}

function removePath() {
	local targetPath="$1"

	if ! test -e "$targetPath"; then
		return
	fi

	if isProgramInstalled rip; then
		rip "$targetPath"
	else
		rm -rf "$targetPath"
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
