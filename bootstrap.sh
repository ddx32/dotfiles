#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit

FORCE=false
for arg in "$@"; do
	case "$arg" in
		--force|-f) FORCE=true ;;
	esac
done

# Install stow if missing
if ! command -v stow &>/dev/null; then
	printf "Installing stow...\n"
	if command -v brew &>/dev/null; then
		brew install stow
	elif command -v pacman &>/dev/null; then
		sudo pacman -S --needed --noconfirm stow
	elif command -v apt-get &>/dev/null; then
		sudo apt-get install -y stow
	else
		printf "Error: could not detect a package manager; install stow manually.\n" >&2
		exit 1
	fi
fi

# Stow dotfiles
if $FORCE; then
	# --adopt pulls existing files into the package, then git restore puts repo versions back
	stow --target="$HOME" --adopt --restow . && git restore .
else
	stow --target="$HOME" --restow .
fi

# Install zsh if missing
if ! command -v zsh &>/dev/null; then
	printf "Installing zsh...\n"
	if command -v brew &>/dev/null; then
		brew install zsh
	elif command -v pacman &>/dev/null; then
		sudo pacman -S --needed --noconfirm zsh
	elif command -v apt-get &>/dev/null; then
		sudo apt-get install -y zsh
	else
		printf "Warning: could not detect a package manager; install zsh manually.\n" >&2
	fi
fi

# Install oh-my-zsh if missing (keep our stowed .zshrc, don't run zsh or chsh)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	printf "Installing oh-my-zsh...\n"
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set zsh as the login shell if it isn't already
ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
	printf "Setting login shell to %s (may prompt for your password)...\n" "$ZSH_PATH"
	grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null || printf '%s\n' "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
	chsh -s "$ZSH_PATH"
fi

printf "***\nDone!\n"
