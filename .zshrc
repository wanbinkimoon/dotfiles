# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

source ~/.config/zsh/exports.sh
source ~/.config/zsh/window-rename.sh
source ~/.config/zsh/nvm-config.sh
source ~/.config/zsh/omz-git-aliases.sh
source ~/.config/zsh/git-aliases.sh
source ~/.config/zsh/custom-aliases.sh
source ~/.config/zsh/pnpm-config.sh
source ~/.config/zsh/secrets.sh
source ~/.config/zsh/zsh-config.sh
source ~/.config/zsh/conda.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



