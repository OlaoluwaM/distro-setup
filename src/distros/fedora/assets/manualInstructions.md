# Manual Setup Instructions

Now that all the automatic stuff are done here is what we need to do manually (in no particular order)

1. Restore important documents backed up with Deja Dup
2. Restore Wallpapers backed up with Deja Dup
3. Restore Fonts backed up with Deja Dup
   1. You can find the font configuration in the assets folder
4. Reinstall locally downloaded rpm applications. Use the `installLocalRpms.sh` script
   1. It can now be called from anywhere
5. Perform other customizations
   1. If using gnome, restore (or reinstall) gnome extensions, settings, and other preferences
   2. Restore keybindings with the `restoreGnomeKeybindings` shell function
   3. Set fish theme: `fast-theme XDG:catppuccin-mocha`
   4. Reconfigure icons, fonts, and cursor from gnome tweaks
6. Restore GPG keys with the `restoreGPGKey <key_id>` shell function. The key id should be passed as an argument and can be found in the directory where the GPG keys are backed up "$HOME/sys-bak/gpg-keys". The directory names are the key ids
7. Sign in to necessary accounts
8. Re-auth with the Github CLI using the web browser following the prompt
9. Restore configuration for firefox add ons
10. Clone repos not cloned during scripted setup
11. Restore shell history using atuin (<https://atuin.sh/docs/commands/sync>)
12. Restore Obsidian in `~/Desktop/digital-brain`
13. For Asus hardware, go through instructions [here](https://asus-linux.org/guides/fedora-guide/)
14. Reinstall the `udev` rule meant to switch the `nvidia_powerd` service on or off depending on whether the system is on battery or AC
     1. The rule and it's accompanying script can be found in the `$DOTS/system` directory
     2. The udev rule should be moved to `/etc/udev/rules.d` and the script should be moved to `/usr/local/bin`
     3. The udev rule and its script cannot be symlinked and must instead be copied to their respective locations
     4. Also note that you will need to turn off the asusd setting meant to handle this to avoid conflicts and race conditions. Settings for the asusd service can be found in `/etc/asusd/asusd.ron`
        1. Specifically, you want to set `disable_nvidia_powerd_on_battery` to `false`
15. Install docker when it's up to data, after going through the asus stuff if using an asus hardware (**Skip if already done with script**)
    1. Docker desktop: <https://docs.docker.com/desktop/install/fedora/>
    2. Docker engine only: <https://docs.docker.com/engine/install/fedora/>
16. Install Ollama using the docker image: <https://github.com/ollama/ollama/blob/main/docs/docker.md> (**Optional**)
    1. Install the nvidia-container-toolkit <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-yum-or-dnf>
       1. Note that this can only be done with a [docker engine installation](https://docs.docker.com/engine/install/fedora/). Docker desktop does not support this
       2. Make use of your local ollama dockerfile to create the right image btw. This docker file is at `$DOTS/custom-dockerfiles/ollama`. Use the command `docker build -t ollama-custom $DOTS/custom-dockerfiles/ollama`
17. Install a local AI client like [Open WebUI](https://github.com/open-webui/open-webui) (**Optional**)
    1. This does not require the cuda toolkit btw, just the nvidia-container-toolkit
    2. We already have docker-compose setup for this
18. Install Astro Nvim by pulling down your [setup repo](https://github.com/OlaoluwaM/nvim-setup) rather than installing from scratch
    1. This has already been scripted
