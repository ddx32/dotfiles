## Sets up the Dock using dockutil

# Remove default apps from the Dock
defaults write com.apple.dock persistent-apps -array

dock_apps=(
	"Safari"
	"Firefox"
	"Google Chrome"
	"Microsoft Edge"
	"Airmail"
	"Messages"
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
	"Podcasts"
	"CARROTweather"
	"Spotify"
	"Affinity Designer"
	"Affinity Photo"
	"Sublime Text"
	"Visual Studio Code"
	"WebStorm"
	"Warp"
	"App Store"
	"System Preferences"
)

echo "\nAdding apps to the Dock:"
for APPNAME in "${dock_apps[@]}"
do
	APPPATH=$(find /Applications /System/Applications -maxdepth 1 -type d -iname "$APPNAME*")
	dockutil --no-restart --add "$APPPATH"
done

killall Dock
