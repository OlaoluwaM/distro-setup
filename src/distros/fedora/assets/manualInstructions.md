# Manual Setup Instructions

Now that all the automatic stuff are done here is what we need to do manually (in no particular order)

1. Restore deja dup backup
2. Perform any necessary customizations
   1. Restore gnome extensions, settings, and other preferences through backup extension
   2. Restore Wallpapers and fonts
   3. Add Terminal paddings
3. Install local RPMs using script
4. Sign in to necessary accounts
5. Setup Bitwarden vault unlock script
6. Login to Protonvpn
7. You will need to login to discord before betterdiscord can act on it
   1. Once that's done, run `betterdiscordctl --d-install flatpak install`
   2. Copy Betterdiscord theme from dotfiles folder to target directory
8. [Authenticate ngrok](https://ngrok.com/docs/getting-started) **(optional)**
9. Restore shell history using attuin
10. Restore Obsidian
11. Add any more customizations

If you need to reference this again, just cat this file
