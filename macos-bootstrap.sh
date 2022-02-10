#!/bin/bash

# Copy the dotfiles to home directory
rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "macos-bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . "$HOME"

# Link iTerm2 preferences file
ln -s "$HOME"/.iterm/com.googlecode.iterm2.plist "$HOME"/Library/Preferences/com.googlecode.iterm2.plist

# Start with the obligatory
xcode-select --install

# Install Rosetta 2 for x86 apps - Apple Silicon only
if [ "$(arch)" = 'arm64' ]; then
  sudo softwareupdate --install-rosetta
fi

# Set sane defaults
source "$HOME/.macos"

# Install Homebrew if not present
if test ! "$(which brew)"; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Zsh & Oh My Zsh
CHSH='no' RUNZSH='no' KEEP_ZSHRC='yes' sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create RSA key pair
[ ! -f "$HOME/.ssh/id_rsa.pub" ] && ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa.pub" -P ""
echo "Add the following RSA public key to wherever you need to (GitHub, cloud servers...):"
cat "$HOME/.ssh/id_rsa.pub"

# Install powerlevel10k custom theme
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Set default shell to zsh (systems older than Catalina only)
[ ! "$SHELL" = "/bin/zsh" ] && chsh -s /bin/zsh
