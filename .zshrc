# Select oh-my-zsh plugins
plugins=(
	colored-man-pages
	direnv
	docker
	git
	macos
	npm
	sudo
)

# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Load Homebrew shell variables
if [ "$(arch)" = 'arm64' ]; then
	BREW_PREFIX="/opt/homebrew"
elif [ "$(arch)" = 'i386' ]; then
	BREW_PREFIX="/usr/local"
fi
eval $(/bin/bash -c "$BREW_PREFIX/bin/brew shellenv")

# Load Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Load aliases
source $HOME/.aliases

# Load kubeconfig
export KUBECONFIG="$KUBECONFIG:$HOME/.kube/config-cdg"

# Load work-related stuff
[ -f "$HOME/.prusa/.config" ] && source "$HOME/.prusa/.config"

# Command not found handler
HOMEBREW_COMMAND_NOT_FOUND_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
if [ -f "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER" ]; then
  source "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER";
fi

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set up $PATH
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin:$(brew --prefix)/opt/python/libexec/bin

# GKE gcloud auth plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# Sublime Text
[ -d "/Applications/Sublime Text.app/Contents/SharedSupport/bin" ] && export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Load starship prompt for alacritty
if [ "$TERM" = "alacritty" ]; then
  eval "$(starship init zsh)"
fi
