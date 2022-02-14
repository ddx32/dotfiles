# ddx32's dotfiles

This is my highly opinionated collection of dotfiles and installation scripts meant to set up a macOS workstation from scratch (and keep its settings in sync with the repo).

Feel free to fork, but make sure you understand what each line does. At a minimum, you should change things like the Git username and email and purchased apps to be installed via Mac App Store (`brew-mas-install.sh`).

Shoutout to Mathias Bynens, [his dotfiles repo](https://github.com/mathiasbynens/dotfiles) and the multiple credited authors in the readme of his repo, who served as a baseline for my configuration.

## Installation

* Clone this repo
* Run `bootstrap.sh`. This copies or updates the dotfiles in your home directory gracefully using `rsync`.
* Run `macos-init.sh` from your home directory to macOS suck a bit less out of the box and set up basic development tools
* Run `brew-mas-install.sh` to install the remaining packages and apps to make life easier
* Note any extra setup required to get a machine up and running and add them to the install scripts

## Notes

Tested only on macOS 12.2+
