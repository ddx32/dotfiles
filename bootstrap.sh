#!/usr/bin/env bash

# This syncs all the dotfiles into the home directory and symlinks config files

cd "$(dirname "${BASH_SOURCE}")" || exit

ICLOUD_DOCS="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh --no-perms . "$HOME"

	if [[ -d "$ICLOUD_DOCS/certs" && -d "$ICLOUD_DOCS/.ssh" ]]; then
		ln -s "$ICLOUD_DOCS/.ssh" "$HOME/.ssh"
		ln -s "$ICLOUD_DOCS/certs" "$HOME/certs"
	else
		echo "Could not find configuration files in iCloud drive, skipping...\n"
	fi
else
	exit 0
fi

printf "***\nDone! next, cd to your home directory and run macos-init.sh\n***\n"
