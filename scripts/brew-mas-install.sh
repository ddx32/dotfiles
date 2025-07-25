# Update Homebrew
brew update
brew upgrade

# Install packages
brew install \
  git \
  coreutils \
  curl \
  direnv \
  dockutil \
  gh \
  gnupg \
  grep \
  helm \
  k9s \
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
  audio-hijack \
  carbon-copy-cloner \
  coconutbattery \
  devonthink \
  discord \
  docker \
  farrago \
  firefox \
  fission \
  google-chrome \
  google-cloud-sdk \
  google-earth-pro \
  insomnia \
  karabiner-elements \
  loopback \
  microsoft-edge \
  netnewswire \
  protonvpn \
  prusaslicer \
  pycharm \
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
  whatsapp

# Install VirtualBox on Intel machines
if [ "$(arch)" = 'i386' ]; then
  brew install --cask virtualbox
fi

brew cleanup

# Install or upgrade node version manager
if [ ! -f "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm" && (
		git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
		cd "$NVM_DIR"
		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	) && \. "$NVM_DIR/nvm.sh"
else
	(
		cd "$NVM_DIR"
		git fetch --tags origin
		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
	) && \. "$NVM_DIR/nvm.sh"
fi

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
  1630573891 # Keyboard Switcheroo
  441258766 # Magnet
  1303222628 # Paprika Recipe manager
)
mas install "${identifiers[@]}"

# Run script to add apps to the Dock
~/scripts/dock.sh
