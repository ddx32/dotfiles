# Source global definitions (Fedora/RHEL)
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

# Portable shell config (shared with zsh)
[ -f "$HOME/.shellrc" ] && . "$HOME/.shellrc"

# --- Bash-specific glue ---
# Completions are cached in ~/.cache and regenerated when the tool's
# binary is newer than the cache (i.e. after an upgrade).
[ -d "$HOME/.cache" ] || mkdir -p "$HOME/.cache"

# kubectl completion
if command -v kubectl >/dev/null 2>&1; then
	_kc="$HOME/.cache/kubectl-completion.bash"
	{ [ -s "$_kc" ] && [ "$_kc" -nt "$(command -v kubectl)" ]; } || kubectl completion bash > "$_kc"
	source "$_kc"
	unset _kc
fi

# pnpm completion
if command -v pnpm >/dev/null 2>&1; then
	_pc="$HOME/.cache/pnpm-completion.bash"
	{ [ -s "$_pc" ] && [ "$_pc" -nt "$(command -v pnpm)" ]; } || pnpm completion bash > "$_pc"
	source "$_pc"
	unset _pc
fi

# starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
