#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit

FORCE=false
for arg in "$@"; do
	case "$arg" in
		--force|-f) FORCE=true ;;
	esac
done

# Check for stow
if ! command -v stow &>/dev/null; then
	printf "Error: 'stow' is not installed. Install it with: brew install stow\n" >&2
	exit 1
fi

# Stow dotfiles
if $FORCE; then
	# --adopt pulls existing files into the package, then git restore puts repo versions back
	stow --target="$HOME" --adopt --restow . && git restore .
else
	stow --target="$HOME" --restow .
fi

printf "***\nDone!\n"
