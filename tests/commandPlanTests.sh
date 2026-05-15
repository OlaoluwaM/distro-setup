#!/usr/bin/env bash

set -euo pipefail

repoRoot="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=src/lib/core.sh
. "$repoRoot/src/lib/core.sh"

testLog="$(mktemp)"
trap 'rm -f "$testLog"' EXIT

function resetMocks() {
	: >"$testLog"
	MOCK_AMD_GPU=false
	MOCK_AVAILABLE_PACKAGES=""
	MOCK_ENABLED_REPOS=""
	MOCK_FEDORA_VERSION=44
	MOCK_FFMPEG_VERSION="ffmpeg mock"
	MOCK_INSTALLED_PACKAGES=""
	MOCK_INTEL_GPU=false
	MOCK_NVIDIA_GPU=false
	MOCK_PROGRAMS=""
	MOCK_NVIDIA_MODULE_BUILT=false
}

function logTestEvent() {
	printf '%s\n' "$*" >>"$testLog"
}

function failTest() {
	local message="$1"

	echo "FAIL: $message" >&2
	echo "--- command plan log ---" >&2
	cat "$testLog" >&2
	exit 1
}

function assertLogContains() {
	local needle="$1"

	if ! grep -Fq "$needle" "$testLog"; then
		failTest "expected log to contain: $needle"
	fi
}

function assertLogNotContains() {
	local needle="$1"

	if grep -Fq "$needle" "$testLog"; then
		failTest "expected log not to contain: $needle"
	fi
}

function runStepScript() {
	local stepPath="$1"

	# shellcheck source=/dev/null
	. "$stepPath" >/dev/null
}

function hasIntelGpu() {
	[[ "$MOCK_INTEL_GPU" == true ]]
}

function hasNvidiaGpu() {
	[[ "$MOCK_NVIDIA_GPU" == true ]]
}

function hasAmdGpu() {
	[[ "$MOCK_AMD_GPU" == true ]]
}

function isProgramInstalled() {
	local program="$1"

	[[ " $MOCK_PROGRAMS " == *" $program "* ]]
}

function isPackageInstalled() {
	local packageName="$1"

	[[ " $MOCK_INSTALLED_PACKAGES " == *" $packageName "* ]]
}

function runOrFail() {
	local failureMessage="$1"
	shift

	logTestEvent "RUN_OR_FAIL|$failureMessage|$*"
}

function runOrWarn() {
	local warningMessage="$1"
	shift

	logTestEvent "RUN_OR_WARN|$warningMessage|$*"
}

function success() {
	logTestEvent "SUCCESS|$*"
}

function alreadyDone() {
	logTestEvent "ALREADY_DONE|$*"
}

function skipStep() {
	logTestEvent "SKIP|$*"
}

function warn() {
	logTestEvent "WARN|$*"
}

function failSetup() {
	logTestEvent "FAIL_SETUP|$*"
	return 1
}

function pauseForRerun() {
	logTestEvent "PAUSE|$*"
}

function rpm() {
	if [[ "$1" == "-E" && "${2:-}" == "%fedora" ]]; then
		printf '%s\n' "$MOCK_FEDORA_VERSION"
		return
	fi

	if [[ "$1" == "-qa" ]]; then
		local pattern="${2:-}"
		local prefix="${pattern%\*}"
		local packageName

		for packageName in $MOCK_INSTALLED_PACKAGES; do
			if [[ "$pattern" == *"*" ]]; then
				[[ "$packageName" == "$prefix"* ]] && printf '%s\n' "$packageName"
			elif [[ "$packageName" == "$pattern" ]]; then
				printf '%s\n' "$packageName"
			fi
		done

		return
	fi

	logTestEvent "RPM|$*"
}

# shellcheck disable=SC2032
function dnf() {
	if [[ "$*" == "repolist --enabled" ]]; then
		local repo
		for repo in $MOCK_ENABLED_REPOS; do
			printf '%s Fedora mock repo\n' "$repo"
		done
		return
	fi

	if [[ "$1" == "-q" && "${2:-}" == "list" && "${3:-}" == "--available" ]]; then
		local args=("$@")
		local packageName="${args[$((${#args[@]} - 1))]}"

		[[ " $MOCK_AVAILABLE_PACKAGES " == *" $packageName "* ]]
		return
	fi

	logTestEvent "DNF|$*"
}

function sudo() {
	logTestEvent "SUDO|$*"
}

function ffmpeg() {
	if [[ "${1:-}" == "-version" ]]; then
		printf '%s\n' "$MOCK_FFMPEG_VERSION"
		return
	fi

	logTestEvent "FFMPEG|$*"
}

function modinfo() {
	[[ "$MOCK_NVIDIA_MODULE_BUILT" == true && "${1:-}" == "nvidia" ]]
}

function testNvidiaSkipsWithoutGpu() {
	resetMocks
	runStepScript "$repoRoot/src/steps/installNvidiaDrivers.sh"

	assertLogContains "SKIP|No NVIDIA GPU detected."
	assertLogNotContains "RUN_OR_FAIL|Could not install NVIDIA proprietary driver packages."
}

function testNvidiaInstallsMissingDriverStack() {
	resetMocks
	MOCK_NVIDIA_GPU=true

	runStepScript "$repoRoot/src/steps/installNvidiaDrivers.sh"

	assertLogContains "RUN_OR_FAIL|Could not install the RPM Fusion free repository package.|sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm"
	assertLogContains "RUN_OR_FAIL|Could not install NVIDIA driver prerequisites.|sudo dnf install -y grubby kmodtool akmods openssl pciutils"
	assertLogContains "SUDO|tee /etc/modprobe.d/blacklist-nouveau.conf"
	assertLogContains "RUN_OR_FAIL|Could not install NVIDIA proprietary driver packages.|sudo dnf install -y kernel-devel kernel-headers akmod-nvidia xorg-x11-drv-nvidia-cuda"
	assertLogContains "RUN_OR_FAIL|Could not build NVIDIA kernel module.|sudo akmods --force"
	assertLogContains "PAUSE|NVIDIA drivers are installed. Reboot before continuing so the proprietary driver can load."
}

function testNvidiaAlreadyInstalledAvoidsReinstall() {
	resetMocks
	MOCK_NVIDIA_GPU=true
	MOCK_INSTALLED_PACKAGES="akmod-nvidia xorg-x11-drv-nvidia"

	runStepScript "$repoRoot/src/steps/installNvidiaDrivers.sh"

	assertLogContains "ALREADY_DONE|NVIDIA proprietary drivers are installed"
	assertLogContains "RUN_OR_WARN|Could not enable one or more NVIDIA power-management services.|sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service nvidia-powerd.service"
	assertLogNotContains "RUN_OR_FAIL|Could not install NVIDIA proprietary driver packages."
	assertLogNotContains "RUN_OR_FAIL|Could not build NVIDIA kernel module."
}

function testMultimediaInstallsIntelCodecs() {
	resetMocks
	MOCK_INTEL_GPU=true

	runStepScript "$repoRoot/src/steps/multiMediaSetup.sh"

	assertLogContains "RUN_OR_FAIL|Could not install ffmpeg.|sudo dnf install -y ffmpeg --allowerasing"
	assertLogContains "RUN_OR_FAIL|Could not install hardware accelerated codec packages.|sudo dnf install -y intel-media-driver"
}

function testMultimediaNvidiaWithoutDriverWarnsAndAvoidsCudaPackage() {
	resetMocks
	MOCK_NVIDIA_GPU=true

	runStepScript "$repoRoot/src/steps/multiMediaSetup.sh"

	assertLogContains "WARN|NVIDIA GPU detected, but the proprietary NVIDIA driver is not installed. NVDEC/NVENC support requires the RPM Fusion NVIDIA driver stack."
	assertLogContains "RUN_OR_FAIL|Could not install hardware accelerated codec packages.|sudo dnf install -y libva-nvidia-driver"
	assertLogNotContains "xorg-x11-drv-nvidia-cuda"
}

function testMultimediaAmdSwapsMesaFreeworldDriver() {
	resetMocks
	MOCK_AMD_GPU=true
	MOCK_AVAILABLE_PACKAGES="mesa-va-drivers-freeworld"
	MOCK_INSTALLED_PACKAGES="mesa-va-drivers"

	runStepScript "$repoRoot/src/steps/multiMediaSetup.sh"

	assertLogContains "RUN_OR_FAIL|Could not swap mesa-va-drivers for mesa-va-drivers-freeworld.|sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld --allowerasing"
}

testNvidiaSkipsWithoutGpu
testNvidiaInstallsMissingDriverStack
testNvidiaAlreadyInstalledAvoidsReinstall
testMultimediaInstallsIntelCodecs
testMultimediaNvidiaWithoutDriverWarnsAndAvoidsCudaPackage
testMultimediaAmdSwapsMesaFreeworldDriver

echo "command plan tests passed"
