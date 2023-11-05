# Fedora

I ❤️ Fedora

## Notes

- The Personal Access Token (PAT) used to authenticate the Github CLI must have a good amount of permissions
  [Screenshot](gnome-shell-screenshot-51NFC1.png)
  [Optimal Permissions](https://drive.google.com/file/d/1ofz21EA94ztBEBr4mv7P-_qufnQ6k99J/view?usp=sharing")

- After each interim exit you ought to run the script again if it hasn't completed. The idea is to not let the script try to do too much at a time. This is also why there are "breaks" within the script, cause....why not :information_desk_person:

- Note that the `AUTO_UPDATES_GIST_URL` env variable is optional
- But the `TOKEN_FOR_GITHUB_CLI` env variable is required

## Todos

- Add script for fetching fonts from google drive and copying them over to the `~/.fonts/` directory

- Add script to download latest zip of cascadia code font from Microsoft, unzip it and store its `ttf` folder in the `~/.local/share/fonts` directory

- Add script to log in to bitwarden on the command line using env variables and setting the necessary credentials into the tokens file [see this page](https://bitwarden.com/help/article/cli/#using-an-api-key)

- Add script to add padding to gnome terminal

- Make it such that breaks only happen when necessary while the script runs

- **Major Change** Rewrite in python

## Notes

- Script should be made executable and ran from the `$HOME` directory
