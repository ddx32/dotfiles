# Update Homebrew
brew update
brew upgrade

# Install packages
brew install \
  git \
  coreutils \
  curl \
  gnupg \
  grep \
  mas \
  openssh \
  python \
  ruby \
  screen \
  timewarrior \
  tree \
  vim \
  warp

# Install Apps via brew cask
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
  karabiner-elements \
  lastfm \
  loopback \
  microsoft-edge \
  netnewswire \
  postman \
  protonvpn \
  prusaslicer \
  reaper \
  signal \
  skype \
  slack \
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
  whatsapp

# Install VirtualBox on Intel machines
if [ "$(arch)" = 'i386' ]; then
  brew install --cask virtualbox
fi

brew cleanup

# Install apps from the App Store using mas
echo "Installing Mac App Store dependencies. Please log in with Apple ID when prompted."
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
mas install "${identifiers[@]}"

# Run script to add apps to the Dock
~/scripts/dock.sh
