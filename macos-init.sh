#!/bin/bash

# In this script we initialize macOS with the bare minimum:
# * Xcode Command line Tools
# * Rosetta 2
# * Homebrew
# * Oh my ZSH
# * iTerm2
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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Oh My Zsh
CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

# Link iTerm2 preferences file and install it
ln -s "$HOME"/.iterm/com.googlecode.iterm2.plist "$HOME"/Library/Preferences/com.googlecode.iterm2.plist
brew install --cask iterm2
dockutil --add /Applications/iTerm.app
brew cleanup

# Set default shell to zsh (systems older than Catalina only)
[ ! "$SHELL" = "/bin/zsh" ] && chsh -s /bin/zsh

# Create RSA key pair
[ ! -f "$HOME/.ssh/id_rsa.pub" ] && ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa.pub" -P ""
echo "Add the following RSA public key to wherever you need to (GitHub, cloud servers...):"
cat "$HOME/.ssh/id_rsa.pub"

# Install powerlevel10k custom theme
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

printf "***\n"
printf "Done!\n"
printf "1. Copy the RSA public key above and put it wherever you need to put it in (GitHub, cloud servers, etc.)\n"
printf "2. Log out/log in to apply changes\n"
printf "3. Open iTerm2.app and continue from there (maybe install some apps using brew-mas-install.sh, too)\n"
printf "***\n"
