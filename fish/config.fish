if status is-interactive
  source ~/.config/fish/completions/omz-git-aliases.sh

  starship init fish | source

  zoxide init fish | source
  # alias cd="z"

  alias ls="eza --icons=always -T -l --level=1 --header --hyperlink"
end
