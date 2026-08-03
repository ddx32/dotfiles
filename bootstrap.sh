#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")" || exit

FORCE=false
for arg in "$@"; do
	case "$arg" in
		--force|-f) FORCE=true ;;
	esac
done

# --- Package manager ----------------------------------------------------

if command -v brew &>/dev/null; then
	PKG=brew
elif command -v pacman &>/dev/null; then
	PKG=pacman
elif command -v apt-get &>/dev/null; then
	PKG=apt
else
	PKG=none
fi

pkg_install() {
	case "$PKG" in
		brew)   brew install "$@" ;;
		pacman) sudo pacman -S --needed --noconfirm "$@" ;;
		apt)    sudo apt-get install -y "$@" ;;
		*)      return 1 ;;
	esac
}

# Binaries installed from GitHub releases land here. Already on PATH via
# .shellrc, which prepends ~/.local/bin.
LOCAL_BIN="$HOME/.local/bin"

# install_release_bin <binary-name> <tarball-url>
# For projects shipping a single binary at the root of a .tar.gz.
install_release_bin() {
	local name="$1" url="$2" tmp
	tmp="$(mktemp -d)" || return 1
	printf "Installing %s from GitHub releases...\n" "$name"
	if curl -fsSL "$url" | tar xz -C "$tmp" "$name" 2>/dev/null; then
		mkdir -p "$LOCAL_BIN"
		install -m 755 "$tmp/$name" "$LOCAL_BIN/$name"
	else
		printf "Warning: could not install %s from %s\n" "$name" "$url" >&2
	fi
	rm -rf "$tmp"
}

# Release tarball targets. starship ships a glibc build for x86_64; zellij
# is musl-only. Anything else falls back to "build/install it yourself".
case "$(uname -m)" in
	x86_64|amd64)
		STARSHIP_TARGET=x86_64-unknown-linux-gnu
		ZELLIJ_TARGET=x86_64-unknown-linux-musl ;;
	aarch64|arm64)
		STARSHIP_TARGET=aarch64-unknown-linux-musl
		ZELLIJ_TARGET=aarch64-unknown-linux-musl ;;
	*)
		STARSHIP_TARGET=
		ZELLIJ_TARGET= ;;
esac

# Install stow if missing
if ! command -v stow &>/dev/null; then
	printf "Installing stow...\n"
	if ! pkg_install stow; then
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
	pkg_install zsh || \
		printf "Warning: could not detect a package manager; install zsh manually.\n" >&2
fi

# Install oh-my-zsh if missing (keep our stowed .zshrc, don't run zsh or chsh)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	printf "Installing oh-my-zsh...\n"
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- Tools the stowed configs depend on ---------------------------------
# These are all loaded behind `command -v` guards, so a missing binary is
# silent: you just get a default prompt / fallback font with no error.

# starship — prompt, configured by .config/starship.toml and hooked in .zshrc.
# Not packaged for Debian/Ubuntu, so fall back to the release binary.
if ! command -v starship &>/dev/null; then
	case "$PKG" in
		brew|pacman) pkg_install starship ;;
		*)
			if [ -n "$STARSHIP_TARGET" ]; then
				install_release_bin starship \
					"https://github.com/starship/starship/releases/latest/download/starship-${STARSHIP_TARGET}.tar.gz"
			else
				printf "Warning: no starship release for %s; install it manually.\n" "$(uname -m)" >&2
			fi ;;
	esac
fi

# zellij — auto-started on interactive shells by .zshrc. Also unpackaged on
# Debian/Ubuntu.
if ! command -v zellij &>/dev/null; then
	case "$PKG" in
		brew|pacman) pkg_install zellij ;;
		*)
			if [ -n "$ZELLIJ_TARGET" ]; then
				install_release_bin zellij \
					"https://github.com/zellij-org/zellij/releases/latest/download/zellij-${ZELLIJ_TARGET}.tar.gz"
			else
				printf "Warning: no zellij release for %s; install it manually.\n" "$(uname -m)" >&2
			fi ;;
	esac
fi

# JetBrainsMono Nerd Font — the family named in .config/alacritty/alacritty.toml.
# Must be the *Nerd Font* build: starship.toml uses patched glyphs, and a
# missing family makes Alacritty fall back to the default monospace silently.
# Debian/Ubuntu's fonts-jetbrains-mono is the unpatched upstream font, so it
# does NOT satisfy this — use the nerd-fonts release there.
install_nerd_font() {
	local dir tmp
	if [ "$(uname -s)" = Darwin ]; then
		dir="$HOME/Library/Fonts"
	else
		dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
	fi

	command -v unzip &>/dev/null || pkg_install unzip || {
		printf "Warning: unzip is required to install the Nerd Font.\n" >&2
		return 1
	}

	tmp="$(mktemp -d)" || return 1
	printf "Installing JetBrainsMono Nerd Font...\n"
	if curl -fsSL -o "$tmp/JetBrainsMono.zip" \
			"https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
		&& unzip -qo "$tmp/JetBrainsMono.zip" -d "$tmp/extract"; then
		mkdir -p "$dir"
		cp "$tmp"/extract/JetBrainsMonoNerdFont-*.ttf "$dir/"
		command -v fc-cache &>/dev/null && fc-cache -f "$dir" &>/dev/null
	else
		printf "Warning: could not install JetBrainsMono Nerd Font.\n" >&2
	fi
	rm -rf "$tmp"
}

if ! { command -v fc-list &>/dev/null && fc-list | grep -qi "JetBrainsMono Nerd Font"; }; then
	case "$PKG" in
		brew)   brew install --cask font-jetbrains-mono-nerd-font ;;
		pacman) pkg_install ttf-jetbrains-mono-nerd ;;
		*)      install_nerd_font ;;
	esac
fi

# Set zsh as the login shell if it isn't already
ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
	printf "Setting login shell to %s (may prompt for your password)...\n" "$ZSH_PATH"
	grep -qxF "$ZSH_PATH" /etc/shells 2>/dev/null || printf '%s\n' "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
	chsh -s "$ZSH_PATH"
fi

printf "***\nDone!\n"
