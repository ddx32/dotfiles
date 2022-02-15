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
  vim

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
  lastfm \
  loopback \
  microsoft-edge \
  netnewswire \
  postman \
  protonvpn \
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
  whatsapp \
  zoomus

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

# Remove default apps from the Dock
defaults write com.apple.dock persistent-apps -array

dock_apps=(
	"Safari"
	"Firefox"
	"Google Chrome"
	"Microsoft Edge"
	"Airmail"
	"Signal"
  "Whatsapp"
  "Telegram"
  "Slack"
  "Discord"
	"Fantastical"
	"Todoist"
	"DEVONthink"
	"1Password"
  "NetNewsWire"
  "CARROTweather"
  "Spotify"
  "Affinity Designer"
  "Affinity Photo"
  "Sublime Text"
  "Visual Studio Code"
  "WebStorm"
  "System Preferences"
)

echo "Adding apps to the Dock:"
for APPNAME in "${dock_apps[@]}"
do
	echo "$APPNAME"
	dockutil --no-restart --add "$(find /Applications -maxdepth 1 -type d -iname "$APPNAME*")"
done

killall Dock
