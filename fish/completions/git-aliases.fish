# Fish completions for Oh-My-Zsh Git plugin aliases
# Based on https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# Aliases

# g is an alias for git
alias g='git'
complete -c g -f -d "Git"

# Git add
alias ga='git add'
complete -c ga -f -d "Git add"
alias gaa='git add --all'
complete -c gaa -f -d "Git add all files"

# Git branch
alias gb='git branch'
complete -c gb -f -d "Git branch"
alias gbd='git branch -d'
complete -c gbd -f -d "Git branch delete"
alias gbD='git branch -D'
complete -c gbD -f -d "Git branch force delete"

# Git commit
alias gc='git commit -v'
complete -c gc -f -d "Git commit verbose"
alias gc!='git commit -v --amend'
complete -c gc! -f -d "Git commit amend"
alias gcb='git checkout -b'
complete -c gcb -f -d "Git checkout new branch"
complete -c gcb -a "(git branch --format='%(refname:short)')" -d "Branch"
alias gclean='git clean -id'
complete -c gclean -f -d "Git clean interactive"
alias gcm='git commit -m'
complete -c gcm -f -d "Git commit with message"
alias gco='git checkout'
complete -c gco -f -d "Git checkout"
complete -c gco -a "(git branch --format='%(refname:short)')" -d "Branch"

# Git diff
alias gd='git diff'
complete -c gd -f -d "Git diff"

# Git fetch
alias gf='git fetch'
complete -c gf -f -d "Git fetch"
alias gfa='git fetch --all --prune'
complete -c gfa -f -d "Git fetch all and prune"
alias gfo='git fetch origin'
complete -c gfo -f -d "Git fetch from origin"

# Git pull/push
alias ggpull='git pull origin (git_current_branch)'
complete -c ggpull -f -d "Git pull from origin for current branch"
alias ggpush='git push origin (git_current_branch)'
complete -c ggpush -f -d "Git push to origin for current branch"
alias ggsup='git branch --set-upstream-to=origin/(git_current_branch)'
complete -c ggsup -f -d "Set upstream to origin/branch"
alias gpsup='git push --set-upstream origin (git_current_branch)'
complete -c gpsup -f -d "Push and set upstream to origin/branch"

# Git help
alias ghh='git help'
complete -c ghh -f -d "Git help"

# Git log
alias gl='git pull'
complete -c gl -f -d "Git pull"
alias glgg='git log --graph'
complete -c glgg -f -d "Git log with graph"
alias glgga='git log --graph --decorate --all'
complete -c glgga -f -d "Git log graph all branches"
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
complete -c glol -f -d "Git log pretty one line"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
complete -c glols -f -d "Git log pretty with stats"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
complete -c glola -f -d "Git log pretty all branches"

# Git merge
alias gm='git merge'
complete -c gm -f -d "Git merge"
alias gmom='git merge origin/master'
complete -c gmom -f -d "Git merge origin/master"
alias gmum='git merge upstream/master'
complete -c gmum -f -d "Git merge upstream/master"
alias gma='git merge --abort'
complete -c gma -f -d "Git merge abort"

# Git push
alias gp='git push'
complete -c gp -f -d "Git push"
alias gpd='git push --dry-run'
complete -c gpd -f -d "Git push dry run"
alias gpf='git push --force-with-lease'
complete -c gpf -f -d "Git push force with lease"
alias gpf!='git push --force'
complete -c gpf! -f -d "Git push force"
alias gpoat='git push origin --all && git push origin --tags'
complete -c gpoat -f -d "Git push origin all and tags"

# Git remote
alias gr='git remote'
complete -c gr -f -d "Git remote"
alias gra='git remote add'
complete -c gra -f -d "Git remote add"
alias grb='git rebase'
complete -c grb -f -d "Git rebase"
alias grba='git rebase --abort'
complete -c grba -f -d "Git rebase abort"
alias grbc='git rebase --continue'
complete -c grbc -f -d "Git rebase continue"
alias grbi='git rebase -i'
complete -c grbi -f -d "Git rebase interactive"
alias grbm='git rebase master'
complete -c grbm -f -d "Git rebase master"
alias grbs='git rebase --skip'
complete -c grbs -f -d "Git rebase skip"
alias grev='git revert'
complete -c grev -f -d "Git revert"
alias grh='git reset'
complete -c grh -f -d "Git reset"
alias grhh='git reset --hard'
complete -c grhh -f -d "Git reset hard"
alias groh='git reset origin/(git_current_branch) --hard'
complete -c groh -f -d "Git reset to origin hard"
alias grm='git rm'
complete -c grm -f -d "Git remove"
alias grmc='git rm --cached'
complete -c grmc -f -d "Git remove cached"
alias grmv='git remote rename'
complete -c grmv -f -d "Git remote rename"
alias grrm='git remote remove'
complete -c grrm -f -d "Git remote remove"
alias grss='git restore --source'
complete -c grss -f -d "Git restore from source"
alias grup='git remote update'
complete -c grup -f -d "Git remote update"

# Git status
alias gsb='git status -sb'
complete -c gsb -f -d "Git status short branch"
alias gsi='git submodule init'
complete -c gsi -f -d "Git submodule init"
alias gss='git status -s'
complete -c gss -f -d "Git status short"
alias gst='git status'
complete -c gst -f -d "Git status"

# Git stash
alias gsta='git stash push'
complete -c gsta -f -d "Git stash push"
alias gstaa='git stash apply'
complete -c gstaa -f -d "Git stash apply"
alias gstc='git stash clear'
complete -c gstc -f -d "Git stash clear"
alias gstd='git stash drop'
complete -c gstd -f -d "Git stash drop"
alias gstl='git stash list'
complete -c gstl -f -d "Git stash list"
alias gstp='git stash pop'
complete -c gstp -f -d "Git stash pop"
alias gstall='git stash --all'
complete -c gstall -f -d "Git stash all"
alias gsw='git switch'
complete -c gsw -f -d "Git switch branch"
complete -c gsw -a "(git branch --format='%(refname:short)')" -d "Local branch"
alias gswc='git switch -c'
complete -c gswc -f -d "Git switch to new branch"

# Git tag
alias gts='git tag -s'
complete -c gts -f -d "Git tag signed"
alias gtv='git tag | sort -V'
complete -c gtv -f -d "Git tag sorted by version"

# Git pull with rebase
alias gup='git pull --rebase'
complete -c gup -f -d "Git pull with rebase"
alias gupa='git pull --rebase --autostash'
complete -c gupa -f -d "Git pull with rebase and autostash"

# Git whatchanged and WIP
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
complete -c gwch -f -d "Git whatchanged"
alias gwip='git add -A; git rm (git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'
complete -c gwip -f -d "Git WIP commit (save work in progress)"
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
complete -c gunwip -f -d "Git undo last WIP commit"

# Helper function used by ggpull/ggpush/etc
function git_current_branch
    set ref (git symbolic-ref --quiet HEAD 2> /dev/null)
    set ret $status
    if test $ret != 0
        if test $ret = 128
            return
        end
        set ref (git rev-parse --short HEAD 2> /dev/null); or return
    end
    echo (string replace -r '^refs/heads/' '' -- $ref)
end