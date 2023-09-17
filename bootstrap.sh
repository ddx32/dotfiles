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

printf "***\nDone! next, cd to your home directory and run macos-init.sh\n***\n"
