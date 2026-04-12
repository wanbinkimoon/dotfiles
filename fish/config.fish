set -gx AWS_REGION eu-west-3

## Agent scripts
fish_add_path ~/.agents/scripts
fish_add_path ~/.agents/scripts/ralph

## Initialize CLAUDE_SOUNDS_MUTED (universal + exported)
set -q CLAUDE_SOUNDS_MUTED; or set -Ux CLAUDE_SOUNDS_MUTED 0

if status is-interactive
  source ~/.config/fish/completions/omz-git-aliases.fish

  starship init fish | source

  zoxide init fish | source
  # alias cd="z"

  alias ls="eza --icons=always -T -l --level=1 --header --hyperlink"
end
