## Sets up the Dock using dockutil

# Remove default apps from the Dock
defaults write com.apple.dock persistent-apps -array

dock_apps=(
	"Safari"
	"Firefox"
	"Google Chrome"
	"Microsoft Edge"
	"Mail"
	"Messages"
	"Signal"
	"Whatsapp"
	"Telegram"
	"Slack"
	"Discord"
	"CARROTweather"
	"Fantastical"
	"Todoist"
	"DEVONthink"
	"1Password"
	"NetNewsWire"
	"Podcasts"
	"Spotify"
	"Affinity Designer"
	"Affinity Photo"
	"Autodesk Fusion 360.app"
	"PrusaSlicer"
	"Sublime Text"
	"Visual Studio Code"
	"PyCharm"
	"Warp"
	"App Store"
	"System Settings"
	"System Preferences"
)

echo "\nAdding apps to the Dock:"
for APPNAME in "${dock_apps[@]}"
do
	APPPATH=$(find /Applications /System/Applications ~/Applications -maxdepth 1 -type d -iname "$APPNAME*")
	dockutil --no-restart --add "$APPPATH"
done

killall Dock
