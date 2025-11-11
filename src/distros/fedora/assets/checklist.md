# Backup Checklist

You should ensure that all of the following have been backed up before moving to another OS

- [ ] **Projects**:  Ensure all important work in version control is pushed ot GitHub, even if the work is incomplete. This goes for all repositories.
  - [ ] Ensure your dotfiles repo upstream is up to date with the latest changes
- [ ] **Important Files (with Deja Dup)**: Ensure that you have backed up copies of all important files and that this backup is as recent as possible
  - [ ] Deja Dup settings: It is important to backup up these settings so you preferences can be restored when you move to another OS and reinstall Deja Dup. You can use the `backupDejaDupConfig` shell function for this.

- [ ] **Wallpapers**: This should be obvious. We do not want to lose our hard earned wallpapers. Back ups are done with Deja Dup. But can be initiated manually using the `backupWallpapers` shell function. There is also a cronjob for this IIRC

- [ ] **Fonts**: We do not want to lose our fonts. Back up is done with Deja Dup.
- [ ] **Manually Installed RPM Packages**: Ensure that you have backed up all manually downloaded `.rpm` files backed up. Backup is done through Deja Dup
  - Ensure that you have the latest version of these packages downloaded
- [ ] **Installed Rust Crates**: Backup crates using the `backupInstalledCrates` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
- [ ] **Github CLI Extensions & Aliases**: Backup Github CLI Extensions and Aliases using the `backupGHExtensions` and `backupGHAliases` shell function respectively. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
- [ ] **Global NPM Packages**: Backup global NPM packages using the `backupGlobalNpmPkgs` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any

- [ ] **GPG Keys**: Backup GPG keys using the `backupGPGKey <key_id>` shell function. It takes a gpg key id as an argument. Changes will reflect in our `$HOME/sys-bak` directory. This directory is not under git, but managed by Deja Dup due to it's security sensitive nature (DejaDup backups are encrypted). You can get the list of gpg keys and their id using either the `gpg --list-secret-keys --keyid-format LONG` or `gpg --list-secret-keys` commands.
    1. These can be restored using the `restoreGPGKey <key_id>` shell function. Note that this function should only be called after we have restored our files from Deja Dup. This function also requires a gpg key id to be passed as an argument
    2. This what the key id looks like `sec   rsa4096/<key_id> YYYY-MM-DD [..] [expires: YYYY-MM-DD]`

- [ ] **Cronjobs**: Backup cronjobs using the `cronBackup` shell function. Changes will reflect in our `distro-setup` project directory. Make sure to commit those updates if any
  - You can use the `cronBackup` alias to backup the cronjobs file

- [ ] **Packages**: Backup any user installed rpm packages. You can use the `dnf history list --reverse` command to see the list of packages installed (some by the user). Add these packages to text file at `src/common/assets/packages.txt` in the `distro-setup` project directory. Commit updates if any
    1. The `addInstalledPackages` is a useful shell function for quickly adding package names to the file
    2. You can also use the `dnf history list --reverse` command to get the list of installed packages
    3. The `addInstalledPackages` function takes n package names as an argument. It will add them all to the package list file. It will prevent duplicates
    4. If you call `addInstalledPackages` with no arguments, it will open the package list file in your editor

- [ ] **Obsidian**: Ensure Obsidian has been fully synced through its sync service

- [ ] **Browser Tabs**: Backup browser tabs with the "Tab Session Manager" add-on. Make sure to sync them to google drive

- [ ] **Keybindings**: Backup keyboard bindings using the `backupGnomeKeybindings` shell function
  - These are saved in our dotfiles under git

- **Gnome Shell Extensions**: Backup the list of currently installed Gnome Shell Extensions using the `backupGnomeExtensions` shell function
  - These are saved in our dotfiles under git

- [ ] Manually sync Atuin shell history, using whatever `atuin` sync command exists
- [ ] Export and backup important AI conversations from OpenWebUI
