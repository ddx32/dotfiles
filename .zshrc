# Select oh-my-zsh plugins
plugins=(
	colored-man-pages
	command-not-found
	docker
	dotenv
	git
	macos
	npm
	sudo
)

# Load Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Load environment variables
set -a; source ~/.env; set +a

export KUBECONFIG="$KUBECONFIG:$HOME/.kube/config-cdg"

# Load Homebrew shell variables
if [ "$(arch)" = 'arm64' ]; then
	BREW_PREFIX="/opt/homebrew"
elif [ "$(arch)" = 'i386' ]; then
	BREW_PREFIX="/usr/local"
fi
eval $(/bin/bash -c "$BREW_PREFIX/bin/brew shellenv")

# Load aliases
source $HOME/.aliases

# Load work-related stuff
[ -f "$HOME/.prusa/.config" ] && source "$HOME/.prusa/.config"

# Command not found handler
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[ -f "$HB_CNF_HANDLER" ] && source "$HB_CNF_HANDLER"

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Autosuggestions
AUTOSUGGESTIONS="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f $AUTOSUGGESTIONS ] && source $AUTOSUGGESTIONS

# ZSH syntax highlighting
ZSH_SYNTAX_HIGHLIGHTING=$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f $ZSH_SYNTAX_HIGHLIGHTING ] && source $ZSH_SYNTAX_HIGHLIGHTING

# Set up $PATH
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin:$(brew --prefix)/opt/python/libexec/bin
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
