#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit

function syncDotFiles() {
	rsync --exclude ".git/" \
		--exclude ".gitignore" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh --no-perms . "$HOME"
}

if [ ! -f "$HOME/icloud-docs" ]; then
	ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/icloud-docs"
fi

if [ ! -f "$HOME/.prusa" ]; then
	ln -s "$HOME/icloud-docs/prusa" "$HOME/.prusa"
fi

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
	syncDotFiles
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		syncDotFiles
	else
		exit 0
	fi;
fi;
unset syncDotFiles

printf "***\nDone!\n"
