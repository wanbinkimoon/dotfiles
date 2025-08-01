# Clean embroider build artifacts
# alias clean-embroider="rm -rf $TMPDIR/embroider"

# yalc add and clean embroider 
# alias yalc-embroider="yalc add $1 && clean-embroider"

# yalc add and clean embroider then install fresh modules with pnpm and run the app
# alias yalc-embroider-run="yalc add $1 && rm -rf $TMPDIR/embroider && pnpm i && pnpm run start"

#check process on port and kills it 
killport() {
    lsof -ti :"$1" | xargs kill -9
}

# Open in nvim with bat preview and fzf 
nvim-open() {
  nvim "$(fzf --preview 'bat --style=numbers --color=always {}')"
}

# Preview in bat with fzf
bat-preview(){ 
  fzf --preview 'bat --style=numbers --color=always {}'
}

function git-clean() {
  git pull
  git fetch -p

  # Check if --force is passed as an argument
  local force_delete=false
  if [[ "$1" == "--force" ]]; then
    force_delete=true
  fi

  # Delete local branches whose upstream has been deleted
  for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
    if $force_delete; then
      # Try to delete the branch with force
      if ! git branch -d "$branch"; then
        # If it fails, it means the branch is not fully merged
        echo "The branch '$branch' is not fully merged. Do you want to delete it? (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
          git branch -D "$branch"
        fi
      fi
    else
      git branch -d "$branch"
    fi
  done
}

# Add zeoxide to the shell
eval "$(zoxide init zsh)"
alias cd="z"

# Eza (better ls) 
alias ls="eza --icons=always -T -l --level=1 --header --hyperlink"
