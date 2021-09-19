#!/usr/bin/env bash

# This script can be used to create folders for new distros
# The --d or --distro option would be used for the distros' name
# For example --d ubuntu or --distro arch

case "$1" in
--d | --distro)
  distroName=$2
  ;;
*)
  echo "Sorry, this script requires a distro name. Try using --d <name of distro> or --distro <name of distro>"
  exit
  ;;
esac

if [ -d "./distros/${distroName}" ]; then
  echo "Directory ./distros/${distroName} already exists"
  exit
fi

mkdir "./distros/${distroName}"
touch "./distros/${distroName}/.env"
touch "./distros/${distroName}/setup.sh"
echo '#!/usr/bin/env bash' >>"./distros/${distroName}/setup.sh"
touch "./distros/${distroName}/README.md"

echo "Created folder for ${distroName} in distros folder"
