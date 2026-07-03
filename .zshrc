# Select oh-my-zsh plugins
plugins=(
	colored-man-pages
	direnv
	docker
	git
	npm
	sudo
)
# macOS-only plugins
[[ "$OSTYPE" == darwin* ]] && plugins+=(macos)

# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Load Homebrew shell variables (macOS only)
if [[ "$OSTYPE" == darwin* ]]; then
	if [ "$(arch)" = 'arm64' ]; then
		BREW_PREFIX="/opt/homebrew"
	else
		BREW_PREFIX="/usr/local"
	fi
	eval "$($BREW_PREFIX/bin/brew shellenv)"
fi

# Load Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Load aliases
source $HOME/.aliases

# Load kubeconfig
export KUBECONFIG="$KUBECONFIG:$HOME/.kube/config-cdg"

# Load work-related stuff
[ -f "$HOME/.prusa/.config" ] && source "$HOME/.prusa/.config"

# Command not found handler (Homebrew)
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_COMMAND_NOT_FOUND_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
  [ -f "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER" ] && source "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER"
fi

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set up $PATH
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
if command -v brew >/dev/null 2>&1; then
	export PATH="$PATH:$(brew --prefix)/opt/python/libexec/bin"
fi

# GKE gcloud auth plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
[ -d "/opt/homebrew/share/google-cloud-sdk/bin" ] && export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# Sublime Text
[ -d "/Applications/Sublime Text.app/Contents/SharedSupport/bin" ] && export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Load starship prompt
eval "$(starship init zsh)"

# pnpm
if [[ "$OSTYPE" == darwin* ]]; then
	export PNPM_HOME="$HOME/Library/pnpm"
else
	export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# pnpm completion — generate on first run, then source
if command -v pnpm >/dev/null 2>&1; then
  [ ! -f "$HOME/completion-for-pnpm.zsh" ] && pnpm completion zsh > "$HOME/completion-for-pnpm.zsh"
  source "$HOME/completion-for-pnpm.zsh"
fi
