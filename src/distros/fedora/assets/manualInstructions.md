# Manual Setup Instructions

Now that all the automatic stuff are done here is what we need to do manually (in no particular order)

1. Restore important documents backed up with Deja Dup
2. Restore Wallpapers backed up with Deja Dup
3. Restore Fonts backed up with Deja Dup
   1. You can find the font configuration in the assets folder
4. Reinstall locally downloaded rpm applications. Use the `installLocalRpms.sh` script
5. Perform other customizations
   1. If using gnome, restore (or reinstall) gnome extensions, settings, and other preferences
   2. Restore keybindings with the `restoreGnomeKeybindings` shell function
6. Restore GPG keys with the `restoreGPGKey` shell function. The key id should be passed as an argument and can be found in the directory where the GPG keys are backed up "$HOME/sys-bak/gpg-keys". The directory names are the key ids
7. Sign in to necessary accounts
8. Restore configuration for firefox add ons
9. Clone repos not cloned during scripted setup
10. Restore shell history using attuin (<https://atuin.sh/docs/commands/sync>)
11. Restore Obsidian in `~/Desktop/digital-brain`
12. For Asus hardware, go through instructions [here](https://asus-linux.org/guides/fedora-guide/)
13. Install docker or docker desktop
