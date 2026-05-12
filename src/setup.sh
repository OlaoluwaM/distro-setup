#!/usr/bin/env bash

setupDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/lib/core.sh
. "$setupDir/lib/core.sh"

envFile="$SETUP_ROOT_DIR/.env"

if ! requireFile "$envFile" "A .env file is required. Check the template at $SETUP_ASSETS_DIR/env_template.txt for the required variables."; then
	failSetup "Missing environment file"
fi

exposeEnvValues "$envFile"
startSudoRefreshLoop

runStep "Update installed packages" "$SETUP_STEPS_DIR/updateSystemPackages.sh" "--refresh"
runStep "Install Zsh" "$SETUP_STEPS_DIR/installZsh.sh"
runStep "Set up Zsh as login shell" "$SETUP_STEPS_DIR/setupZsh.sh"
runStep "Install Git" "$SETUP_STEPS_DIR/installGit.sh"
runStep "Install curl and wget" "$SETUP_STEPS_DIR/installCurlWget.sh"
runStep "Install DNF plugins" "$SETUP_STEPS_DIR/installDnfPlugins.sh"
runStep "Swap libcurl-minimal for libcurl" "$SETUP_STEPS_DIR/swapLibcurl.sh"
runStep "Install Oh My Zsh" "$SETUP_STEPS_DIR/installOMZ.sh"
runStep "Install GitHub CLI" "$SETUP_STEPS_DIR/installGithubCLI.sh"
runStep "Authenticate GitHub CLI" "$SETUP_STEPS_DIR/authenticateGithubCLI.sh"
runStep "Add SSH key to GitHub" "$SETUP_STEPS_DIR/addSSHToGithub.sh" "Personal Laptop $(cat /etc/fedora-release)"
runStep "Bootstrap filesystem directories" "$SETUP_STEPS_DIR/bootstrapFsDirStructure.sh"
runStep "Clone GitHub repos" "$SETUP_STEPS_DIR/cloneGitRepos.sh"
runStep "Set up Zsh plugins" "$SETUP_STEPS_DIR/setupZshPlugins.sh"
runStep "Install Docker" "$SETUP_STEPS_DIR/installDocker.sh"
runStep "Install VS Code" "$SETUP_STEPS_DIR/installVSCode.sh"
runStep "Update installed packages" "$SETUP_STEPS_DIR/updateSystemPackages.sh"

quickBreak

runStep "Install system packages" "$SETUP_STEPS_DIR/installSystemPackages.sh"
runStep "Update installed packages" "$SETUP_STEPS_DIR/updateSystemPackages.sh"

quickBreak

runStep "Install Google Chrome" "$SETUP_STEPS_DIR/installChrome.sh"
runStep "Install Proton VPN" "$SETUP_STEPS_DIR/installProtonvpn.sh"
runStep "Set up Node with NVM" "$SETUP_STEPS_DIR/setupNodeWithNVM.sh"
runStep "Install miscellaneous tools" "$SETUP_STEPS_DIR/installMisc.sh"
runStep "Set up AstroNvim" "$SETUP_STEPS_DIR/astroNvimSetup.sh"
runStep "Install Rust crates" "$SETUP_STEPS_DIR/installCrates.sh"
runStep "Install global NPM packages" "$SETUP_STEPS_DIR/installGlobalNpmPackages.sh"
runStep "Symlink dotfiles" "$SETUP_STEPS_DIR/symlinkDotfiles.sh"
runStep "Restore cron jobs" "$SETUP_STEPS_DIR/restoreCronjobs.sh"
runStep "Install GitHub CLI extensions" "$SETUP_STEPS_DIR/ghExtensionsInstall.sh"
runStep "Restore GitHub CLI aliases" "$SETUP_STEPS_DIR/ghAliasRestore.sh"

quickBreak

runStep "Set up automatic updates" "$SETUP_STEPS_DIR/setupAutomaticUpdates.sh"
runStep "Set up Flathub" "$SETUP_STEPS_DIR/setupFlathub.sh"
runStep "Install Haskell" "$SETUP_STEPS_DIR/installHaskell.sh"
runStep "Install Haskell executables" "$SETUP_STEPS_DIR/installHaskellExecs.sh"
runStep "Install Nvidia container toolkit" "$SETUP_STEPS_DIR/installNvidiaContainerKit.sh"
runStep "Set up multimedia support" "$SETUP_STEPS_DIR/multiMediaSetup.sh"
runStep "Install Catppuccin cursors" "$SETUP_STEPS_DIR/ricing/gnome/catppuccin/cursors.sh"
runStep "Install Colloid icons" "$SETUP_STEPS_DIR/ricing/gnome/colloid/icons.sh"

echo "Success! We're so back baby!! Now for the things that could not be automated...."
echo "For those, you can refer to the manual instructions"
cat "$SETUP_ASSETS_DIR/manualInstructions.md"

stopSudoRefreshLoop
