#!/bin/bash

# In this script we initialize macOS with the bare minimum:
# * Xcode Command line Tools
# * Rosetta 2
# * Homebrew
# * Oh my ZSH
# * iTerm2
# * Node.js & nvm
# * Generate RSA key pair
# * Set macOS defaults and clean up the Dock
#

# Start with the obligatory
xcode-select --install

# Install Rosetta 2 for x86 apps - Apple Silicon only
if [ "$(arch)" = 'arm64' ]; then
  sudo softwareupdate --install-rosetta
fi

# Set sane macOS defaults
source "$HOME/.macos"

# Install Homebrew if not present
if test ! "$(which brew)"; then
  echo "Installing homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Tap the repos
brew tap homebrew/core
brew tap homebrew/cask
brew tap homebrew/cask-fonts
brew tap homebrew/command-not-found

# Clean up the Dock
brew update
brew install dockutil
dockutil \
	--remove Launchpad \
	--remove Mail \
	--remove Maps \
	--remove FaceTime \
	--remove Calendar \
	--remove Contacts \
	--remove Reminders \
	--remove Notes \
	--remove TV \
	--remove Music \
	--remove Podcasts \

# Install Oh My Zsh
if [[ -z "${ZSH}" ]]; then
	CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install and set up iTerm
brew install --cask iterm2 font-fira-code-nerd-font
ln -s "$HOME"/.config/com.googlecode.iterm2.plist "$HOME"/Library/Preferences/com.googlecode.iterm2.plist
dockutil --add /Applications/iTerm.app

# Set default shell to zsh (systems older than Catalina only)
[ ! "$SHELL" = "/bin/zsh" ] && chsh -s /bin/zsh

# Install NVM and Node.js LTS
brew install nvm
\. "/usr/local/opt/nvm/nvm.sh"
nvm install --lts

# Install ZSH plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Install powerlevel10k theme
brew install romkatv/powerlevel10k/powerlevel10k

# Install a colorful replacement for ls
brew install exa

# Create RSA key pair
[ ! -f "$HOME/.ssh/id_rsa" ] && ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa" -P ""
echo "Add the following RSA public key to wherever you need to (GitHub, cloud servers...):"
cat "$HOME/.ssh/id_rsa.pub"

printf "***\n"
printf "Done!\n"
printf "1. Copy the RSA public key above and put it wherever you need to put it in (GitHub, cloud servers, etc.)\n"
printf "2. Log out/log in to apply changes\n"
printf "3. Open iTerm2.app and continue from there (maybe install some apps using brew-mas-install.sh, too)\n"
printf "***\n"
