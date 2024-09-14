# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# source ~/.config/zsh/nvm-config.sh
source ~/.config/zsh/omz-git-aliases.sh
source ~/.config/zsh/git-aliases.sh
source ~/.config/zsh/custom-aliases.sh
source ~/.config/zsh/pnpm-config.sh
source ~/.config/zsh/secrets.sh
# source ~/.config/zsh/android-studio-config.sh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Add zeoxide to the shell
eval "$(zoxide init zsh)"
alias cd="z"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
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


# Bat (better cat)
export BAT_THEME=tokyonight_night

# Eza (better ls) 
alias ls="eza --icons=always"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

PATH=~/.console-ninja/.bin:$PATH