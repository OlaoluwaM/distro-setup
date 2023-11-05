# Backup Checklist

You should ensure that all of the following have been backed up before moving to another OS

1. **Projects**:  Ensure all important work in version control is pushed ot GitHub, even if the work is incomplete. This goes for all repositories.
   1. Ensure your dotfiles repo upstream is up to date with the latest changes
2. **Important Files (with Deja Dup)**: Ensure that you have backed up copies of all important files and that this backup is as recent as possible
   1. Deja Dup settings: It is important to backup up these settings so you preferences can be restored when you move to another OS and reinstall Deja Dup. You can use the `backupDejaDupConfig` shell function for this.
3. **Wallpapers**: This should be obvious. We do not want to lose our hard earned wallpapers. Back ups are done with Deja Dup. But can be initiated manually using the `backupWallpapers` shell function. There is also a cronjob for thi IIRC
4. **Fonts**: We do not want to lose our fonts. Back up is done with Deja Dup.
5. **Manually Installed RPM Packages**: Ensure that you have backed up all manually downloaded `.rpm` files backed up. Backup is done through Deja Dup
6. **Installed Rust Crates**: Backup crates using the `backupInstalledCrates` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
7. **Github CLI Extensions & Aliases**: Backup Github CLI Extensions and Aliases using the `backupGHExtensions` and `backupGHAliases` shell function respectively. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
8. **DNF Aliases**: Backup your DNF Aliases using the `backupDnfAliases` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
9. **Global NPM Packages**: Backup global NPM packages using the `backupGlobalNpmPkgs` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
10. **GPG Keys**: Backup GPG keys using the `backupGPGKeys` shell function. It takes a gpg key id as an argument. Changes will reflect in our `$HOME/sys-bak` directory. This directory is not under git, but managed by Deja Dup due to it's security sensitive nature. You can get the list of gpg keys using either the `gpg --list-secret-keys --keyid-format LONG` or `gpg --list-secret-keys` commands
    1. These can be restored using the `restoreGPGKeys` shell function. Note that this function should only be called after we have restored our files from Deja Dup
11. **Cronjobs**: Backup cronjobs using the `cronBackup` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
12. **Packages**: Backup any user installed rpm packages. You can use the `dnf history list --reverse` command to see the list of packages installed (some by the user). Add these packages to text file at `src/common/assets/packages.txt` in the `distro-setup` project directory. Commit updates if any
    1. The `addInstalledPackages` is a useful shell function for quickly adding package names to the file
13. **Fedora Coprs**: Backup enabled copr repo names using to the `src/distros/fedora/assets/coprs.txt` file in the `distro-setup` project directory. Commit updates if any. You can find the list of enabled coprs by navigating to the `/etc/yum.repos.d` directory. Copr repos have a "_copr:copr" prefix in their names
14. **Obsidian**: Ensure Obsidian has been fully synced through its sync service
