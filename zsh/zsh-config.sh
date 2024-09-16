# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# FZF Dracula theme 
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

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
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add zeoxide to the shell
eval "$(zoxide init zsh)"
alias cd="z"

# Add zsh-completions to the shell
zstyle ':completion:*' menu select

# Eza (better ls) 
alias ls="eza --icons=always -T --level=1 --header --hyperlink"


# Bat (better cat)
export BAT_THEME='Dracula'

# Open in nvim with bat preview and fzf 
search_open() {
    nvim "$(fzf --preview 'bat --style=numbers --color=always {}')"
}
