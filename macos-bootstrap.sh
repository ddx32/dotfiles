#!/bin/bash

echo "Create an SSH key..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

# Install Homebrew if not present
if test ! "$(which brew)"; then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Adding Homebrew to \$PATH"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME"/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Rosetta 2 for x86 apps - Apple Silicon only
if [ "$(arch)" = 'arm64' ]; then
  sudo softwareupdate --install-rosetta
fi

echo "Git config"
git config --global user.name "Filip Růžička"
git config --global user.email f@filipruzicka.com

# Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

# Install powerlevel10k custom theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
