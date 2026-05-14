#!/usr/bin/env bash

# Directory containing RPM files
RPM_DIR="$HOME/Downloads/rpms" # Replace with your directory path

# Check if the directory exists
if [ ! -d "$RPM_DIR" ]; then
	skipStep "Directory $RPM_DIR does not exist."
	return
fi

echo "Installing local RPMs..."

rpms_to_skip=("slack" "cuda" "mailspring")
failedInstallCount=0
foundInstallableRpm=false

function shouldSkipLocalRpm() {
	local rpm_file="$1"
	local pattern

	for pattern in "${rpms_to_skip[@]}"; do
		if [[ "$rpm_file" == *"$pattern"* ]]; then
			return 0
		fi
	done

	return 1
}

# Find all rpms in the RPM directory
while read -r rpm_file; do
	if shouldSkipLocalRpm "$rpm_file"; then
		echo "Skipping $rpm_file..."
		echo -e "\n"
		continue
	fi

	foundInstallableRpm=true
	packageName="$(rpm -qp --queryformat '%{NAME}' "$rpm_file" 2>/dev/null || true)"

	if [[ -n "$packageName" ]] && isPackageInstalled "$packageName"; then
		alreadyDone "$packageName is installed"
	else
		echo "Installing $rpm_file..."
		if ! sudo dnf install "$rpm_file" -y; then
			warn "Could not install $rpm_file"
			((failedInstallCount++))
		fi
	fi

	echo -e "\n"
done < <(find "$RPM_DIR" -type f -name '*.rpm')

if [[ $foundInstallableRpm == false ]]; then
	alreadyDone "No installable local RPMs found in $RPM_DIR"
	return
fi

if [[ $failedInstallCount -gt 0 ]]; then
	failSetup "$failedInstallCount local RPM install(s) failed."
fi

success "Local RPM installation complete"
