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
6. Restore GPG keys with the `restoreGPGKey` shell function. The key id should be passed as an argument and can be found in the directory where the GPG keys are backed up "$HOME/sys-bak/gpg-keys". The directory names are the key ids
7. Sign in to necessary accounts
8. Re-auth with the Github CLI following the prompt
9. Restore configuration for firefox add ons
10. Clone repos not cloned during scripted setup
11. Restore shell history using attuin (<https://atuin.sh/docs/commands/sync>)
12. Restore Obsidian in `~/Desktop/digital-brain`
13. For Asus hardware, go through instructions [here](https://asus-linux.org/guides/fedora-guide/)
14. Install docker or docker desktop when it's up to data, after going through the asus stuff if using an asus hardware (**Optional**)
    1. Docker desktop: <https://docs.docker.com/desktop/install/fedora/>
    2. Docker engine only: <https://docs.docker.com/engine/install/fedora/>
15. Install CUDA toolkit if needed, after going through the asus stuff if using an asus hardware (**Optional**)
    1. <https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Fedora>
    2. Use the network install step
    3. Install only the cuda toolkit version that aligns with your nvidia driver version: <https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html#id4>
    4. **You likely won't need to install CUDA as Ollama only requires the CUDA drivers which come with installing the non-free nvidia drivers**
16. Install Ollama using the docker image: <https://github.com/ollama/ollama/blob/main/docs/docker.md> (**Optional**)
    1. Install the nvidia-container-toolkit <https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-yum-or-dnf>
       1. Note that this can only be done with a [docker engine installation](https://docs.docker.com/engine/install/fedora/). Docker desktop does not support this
       2. Make use of your local ollama dockerfile to create the right image btw. This docker file is at `$DOTS/custom-dockerfiles/ollama`. Use the command `docker build -t ollama-custom $DOTS/custom-dockerfiles/ollama`
17. Install a local AI client like [Open WebUI](https://github.com/open-webui/open-webui) (**Optional**)
    1. This does not require the cuda toolkit btw, just the nvidia-container-toolkit
    2. We already have docker-compose setup for this
18. Install Astro Nvim by pulling down your [setup repo](https://github.com/OlaoluwaM/nvim-setup) rather than installing from scratch
