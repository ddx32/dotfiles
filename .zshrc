# Portable shell config (shared with bash). Sourced before oh-my-zsh so
# Homebrew's site-functions land in FPATH before compinit runs.
[ -f "$HOME/.shellrc" ] && source "$HOME/.shellrc"

# Select oh-my-zsh plugins
plugins=(
	colored-man-pages
	docker
	git
	npm
	sudo
)
[ "$(uname -s)" = Darwin ] && plugins+=(macos)

# Load Oh-my-zsh (if installed)
export ZSH="$HOME/.oh-my-zsh"
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Zsh-specific glue (completions need oh-my-zsh's compinit first) ---

# Completions are cached in ~/.cache and regenerated when the tool's
# binary is newer than the cache (i.e. after an upgrade).
[ -d "$HOME/.cache" ] || mkdir -p "$HOME/.cache"

# kubectl completion
if command -v kubectl >/dev/null 2>&1; then
	_kc="$HOME/.cache/kubectl-completion.zsh"
	{ [ -s "$_kc" ] && [ "$_kc" -nt "$(command -v kubectl)" ]; } || kubectl completion zsh > "$_kc"
	source "$_kc"
	unset _kc
fi

# pnpm completion
if command -v pnpm >/dev/null 2>&1; then
	_pc="$HOME/.cache/pnpm-completion.zsh"
	{ [ -s "$_pc" ] && [ "$_pc" -nt "$(command -v pnpm)" ]; } || pnpm completion zsh > "$_pc"
	source "$_pc"
	unset _pc
fi

# direnv (hooked explicitly, not via the oh-my-zsh plugin, so it also
# works on machines without oh-my-zsh)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# zellij — auto-start a session on interactive shells (skip when already
# inside one; respects ZELLIJ_AUTO_ATTACH / ZELLIJ_AUTO_EXIT).
if command -v zellij >/dev/null 2>&1 && [ -z "$ZELLIJ" ]; then
	case $- in
		*i*) eval "$(zellij setup --generate-auto-start zsh)" ;;
	esac
fi
