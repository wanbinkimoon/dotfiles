# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# completion using arrow keys (based on commands)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
autoload -Uz compinit && compinit -C -u

# source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# ZSH_HIGHLIGHT_MAXLENGTH=300
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=37,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=37,underline
ZSH_HIGHLIGHT_STYLES[command]=fg=15
ZSH_HIGHLIGHT_STYLES[builtin]=fg=15
ZSH_HIGHLIGHT_STYLES[arg0]=fg=15
ZSH_HIGHLIGHT_STYLES[path]=fg=10
ZSH_HIGHLIGHT_STYLES[default]=fg=6

# Add zsh-completions to the shell
zstyle ':completion:*' menu select

# Ensure emacs mode is active (disable vim mode)
bindkey -e


