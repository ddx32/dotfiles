#!/bin/bash

echo "Create an SSH key..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Adding Homebrew to \$PATH"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Updating homebrew..."
brew update

if [ $(arch) = 'arm64' ]; then
  echo "Install Rosetta 2 for x86 apps"
  sudo softwareupdate --install-rosetta
fi

echo "Installing packages..."
brew install \
  git \
  curl \
  gpsbabel \
  mas \
  node@16 \
  python \
  ruby \
  tree \
  vim

echo "Git config"
git config --global user.name "Filip Růžička"
git config --global user.email f@filipruzicka.com

echo "Installing cask apps..."
brew install --cask \
  1password \
  adobe-acrobat-reader \
  adobe-creative-cloud \
  airfoil \
  carbon-copy-cloner \
  coconutbattery \
  devonthink \
  discord \
  docker \
  fantastical \
  farrago \
  firefox \
  fission \
  google-chrome \
  google-earth-pro \
  iterm2 \
  lastfm \
  loopback \
  netnewswire \
  postman \
  protonvpn \
  reaper \
  signal \
  skype \
  soundsource \
  spotify \
  steam \
  sublime-text \
  teamviewer \
  telegram \
  the-unarchiver \
  todoist \
  transmit \
  typinator \
  visual-studio-code \
  vlc \
  webstorm \
  whatsapp \
  wireshark \
  zoomus

brew cleanup

echo "Installing apps from App Store using mas..."
identifiers=(
  918858936 # Airmail
  824171161 # Affinity Designer
  824183456 # Affinity Photo
  488548690 # Card Shark Solitaire
  993487541 # Carrot Weather
  411643860 # DaisyDisk
  768053424 # Gapplin
  411052274 # Garmin BaseCamp
  439697913 # Icon Slate
  441258766 # Magnet
  1303222628 # Paprika Recipe manager
)

mas install ${identifiers[@]}


#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting ZSH as shell..."
chsh -s /bin/zsh

echo "Done!"
