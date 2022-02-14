# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="robbyrussell"

plugins=(
	colored-man-pages
	command-not-found
	docker
	git
	macos
	npm
	sudo
)

source $ZSH/oh-my-zsh.sh

# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases
source $HOME/.aliases

# Load Homebrew shell variables
BREW_PREFIX=$(brew --prefix)
eval $(/bin/bash -c "$BREW_PREFIX/bin/brew shellenv")

# Command not found handler
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[ -f "$HB_CNF_HANDLER" ] && source "$HB_CNF_HANDLER"

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Autosuggestions
AUTOSUGGESTIONS="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f $AUTOSUGGESTIONS ] && source $AUTOSUGGESTIONS

# ZSH syntax highlighting
ZSH_SYNTAX_HIGHLIGHTING=$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f $ZSH_SYNTAX_HIGHLIGHTING ] && source $ZSH_SYNTAX_HIGHLIGHTING

export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin

[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
[[ -f /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Final command: load Starship prompt
eval "$(starship init zsh)"
