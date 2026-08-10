# ddx32's dotfiles

My personal, opinionated collection of dotfiles and setup scripts. Portable across **macOS and Linux**, managed with [GNU Stow](https://www.gnu.org/software/stow/): the repo is symlinked into your home directory, so edits live in one git-tracked place.

Feel free to fork, but understand what each line does first. At a minimum, change the Git name/email (`.gitconfig`), the espanso snippets (`.config/espanso/match/base.yml`), and — on macOS — the apps installed via `scripts/`.

Shoutout to Mathias Bynens and [his dotfiles repo](https://github.com/mathiasbynens/dotfiles), which served as the original baseline.

## Installation

```sh
git clone git@github.com:ddx32/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` is cross-platform and idempotent. It:

1. Installs **stow** if missing (detects `brew`, `pacman`, or `apt-get`).
2. Symlinks the dotfiles into `$HOME` with `stow --restow`.
3. Installs **zsh** and **oh-my-zsh** if missing (keeping this repo's `.zshrc`).
4. Installs the tools the stowed configs depend on: **starship**, **zellij**,
   and **JetBrainsMono Nerd Font**.
5. Sets zsh as your login shell.

Step 4 matters because every one of those is loaded behind a `command -v`
guard: if the binary is missing the config silently does nothing, so you get
the default oh-my-zsh prompt (or a fallback font) with no error to explain it.

Where a package manager carries them (`brew`, `pacman`) they're installed from
it. Debian/Ubuntu packages neither starship nor zellij, so those fall back to
the upstream release binaries in `~/.local/bin` — which `.shellrc` puts on
PATH. The font falls back to the [nerd-fonts][nf] release; note that Debian's
`fonts-jetbrains-mono` is the *unpatched* upstream font and does **not** work,
since `starship.toml` uses Nerd Font glyphs.

[nf]: https://github.com/ryanoasis/nerd-fonts

### First run over existing files

If you already have real files where symlinks need to go (e.g. an existing `~/.zshrc`), stow will refuse to overwrite them. Run:

```sh
./bootstrap.sh --force
```

This uses `stow --adopt` to pull the existing files into the repo, then `git restore .` to replace them with the repo's versions — leaving the originals as symlinks. Review with `git status` afterward.

## What gets stowed

Everything at the repo root **except** the entries in `.stow-local-ignore` is symlinked into `$HOME`. That includes `.zshrc`, `.aliases`, `.gitconfig`, `.tmux.conf`, `.editorconfig`, `bin/`, everything under `.config/` (alacritty, starship, espanso, plus the macOS-only aerospace/ghostty), and `.claude/skills/` (custom Claude Code skills; stow folds into the existing `~/.claude`, leaving its local state alone).

**Not stowed** (repo-only): `bootstrap.sh`, `README.md`, `LICENSE`, git metadata, and the macOS-only `scripts/` and `.macos` (see below).

## Cross-platform behavior

The shell config guards platform-specific pieces so a single `.zshrc` works everywhere:

- Homebrew shellenv, the `macos` oh-my-zsh plugin, and brew-based PATH entries load **only on macOS**.
- `PNPM_HOME` and other paths resolve per-OS.
- `bin/mount-efi.sh` is macOS-only and exits with a message elsewhere; `bin/server-here.sh` runs anywhere Docker is available.

## macOS-only setup

These live in the repo but are **not** stowed — run them explicitly on a fresh Mac:

- `scripts/macos-init.sh` — Xcode CLI tools, Rosetta, Homebrew, oh-my-zsh plugins, iTerm2, and `.macos` system defaults. (The terminal font is *not* here — `bootstrap.sh` owns it cross-platform, since the stowed `alacritty.toml` is what names the family.)
- `scripts/brew-mas-install.sh` — installs formulae, casks, and Mac App Store apps.
- `scripts/dock.sh` — rebuilds the Dock from a fixed app list.
- `scripts/icloud-files.sh` — symlinks iCloud Drive locations.
- `.macos` — a large batch of `defaults write` tweaks (sourced by `macos-init.sh`).

## Machine-local & private overrides

Kept out of the repo so per-machine and sensitive settings stay local:

- `~/.config/alacritty/local.toml` — machine-local Alacritty overrides (e.g. font size); imported by `alacritty.toml`, silently skipped if absent.
- `~/.prusa/.config` — work-specific shell config, sourced by `.zshrc` if present.

## Notes

Tested on macOS 12.2–14.3, Arch Linux, and Linux Mint 22.3 (Ubuntu 24.04).

`alacritty.toml` keeps `import` and `live_config_reload` at the root rather
than under `[general]`: that section only exists in Alacritty 0.14+, and older
versions discard the whole unknown section (`Unused config key: general`),
silently taking the local-override import with it. 0.14+ still honours the
root-level keys, just with a deprecation warning.
