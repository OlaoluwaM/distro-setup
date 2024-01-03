#!/bin/bash

# Save the current directory
ORIGINAL_DIR=$(pwd)

# Directory containing RPM files
RPM_DIR="$HOME/Downloads/rpms" # Replace with your directory path

# Check if the directory exists
if [ ! -d "$RPM_DIR" ]; then
    echo "Directory $RPM_DIR does not exist."
    exit 1
fi

echo "Installing local RPMs..."

# Navigate to the directory
cd "$RPM_DIR" || exit 1

# Install all RPM files in the directory
for rpm_file in *.rpm; do
    if [ -f "$rpm_file" ]; then
        echo "Installing $rpm_file..."
        sudo dnf install "$rpm_file" -y
    else
        echo "No RPM files found in $RPM_DIR."
        break
    fi
done

# Navigate back to the original directory
cd "$ORIGINAL_DIR" || exit 1

echo "Installation complete."
