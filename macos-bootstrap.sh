#!/bin/bash

# Install Rosetta 2 for x86 apps - Apple Silicon only
if [ "$(arch)" = 'arm64' ]; then
  sudo softwareupdate --install-rosetta
fi

# Create RSA key pair
[ ! -f "$HOME/.ssh/id_rsa.pub" ] && ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa.pub" -P ""
echo "Add the following RDA public key to wherever you need to (GitHub, cloud servers...):"
cat "$HOME/.ssh/id_rsa.pub"

# Install Homebrew if not present
if test ! "$(which brew)"; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Zsh & Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Add Homebrew to $PATH
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME"/.extras

# Sett ZSH as shell
chsh -s /bin/zsh

# Install powerlevel10k custom theme
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
