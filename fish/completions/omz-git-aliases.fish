#!/usr/bin/env fish

# Fish version of Oh My Zsh Git aliases
# Based on Oh My Zsh Git plugin:
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# Helper function to get current git branch
function git_current_branch
    set -l ref (git symbolic-ref --quiet HEAD 2>/dev/null)
    set -l ret $status
    if test $ret -ne 0
        if test $ret -eq 128
            return
        end
        set ref (git rev-parse --short HEAD 2>/dev/null); or return
    end
    echo (string replace 'refs/heads/' '' $ref)
end

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gcb='git checkout -b'
alias gclean='git clean -id'
alias gcm='git commit -m'
alias gco='git checkout'

alias gd='git diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias ggpull='git pull origin (git_current_branch)'
alias ggpush='git push origin (git_current_branch)'

alias ggsup='git branch --set-upstream-to=origin/(git_current_branch)'
alias gpsup='git push --set-upstream origin (git_current_branch)'

alias ghh='git help'

alias gl='git pull'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"

alias gm='git merge'
alias gmom='git merge origin/master'
alias gmum='git merge upstream/master'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias 'gpf!'='git push --force'
alias gpoat='git push origin --all && git push origin --tags'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/(git_current_branch) --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grss='git restore --source'
alias grup='git remote update'

alias gsb='git status -sb'
alias gsi='git submodule init'
alias gss='git status -s'
alias gst='git status'

alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstall='git stash --all'
alias gsw='git switch'
alias gswc='git switch -c'

alias gts='git tag -s'
alias gtv='git tag | sort -V'

alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm (git ls-files --deleted) 2>/dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

function gunwip
    git log -n 1 | grep -q -c "\-\-wip\-\-"; and git reset HEAD~1
end
