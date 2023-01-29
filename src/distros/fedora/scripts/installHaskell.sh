#!/usr/bin/env bash

# Install Haskell via GHCup
# https://www.haskell.org/ghcup/install/

echo "Installing Haskell via GHCup..."

if isProgramInstalled ghci; then
  echo "Haskell has already been installed. Skipping..."
  return
fi

echo "Checking if all required dependencies are installed..."
INSTALL_DEPS=("gcc" "gcc-c++" "gmp" "gmp-devel" "make" "ncurses" "xz" "perl" "curl")
DEPS_TO_INSTALL=()

for dep in "${INSTALL_DEPS[@]}"; do
  if ! (rpm -qa | grep -E "$dep" &>/dev/null); then
    echo "$dep is required, but has not been installed"
    DEPS_TO_INSTALL+=("$dep")
  fi
done
echo -e "\n"

if [[ ${#DEPS_TO_INSTALL[@]} -gt 0 ]]; then
  echo "Installing missing dependencies: ${DEPS_TO_INSTALL[*]}..."
  sudo dnf install -y "${DEPS_TO_INSTALL[@]}"
  echo "All missing dependencies have been installed!"
else
  echo "All required dependencies have already been installed"
fi
echo -e "\n"

echo "Installing Haskell..."
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
echo -e "Installation complete\n"

if doesFileExist "$HOME/.ghcup/env"; then
  echo "Sourcing .ghcup/env..."
  source "$HOME/.ghcup/env"
  echo "Done!"
fi
