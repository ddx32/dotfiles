#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit

# Create symlinks for iCloud docs and work dir
if [ ! -e "$HOME/icloud-docs" ]; then
	ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/icloud-docs"
fi

if [ ! -e "$HOME/.prusa" ]; then
	ln -s "$HOME/icloud-docs/prusa" "$HOME/.prusa"
fi

# Stow dotfiles
stow --target="$HOME" --restow .

printf "***\nDone!\n"
