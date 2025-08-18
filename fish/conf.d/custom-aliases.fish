#check process on port and kills it 
function killport
    lsof -ti :$argv[1] | xargs kill -9
end

# Open in nvim with bat preview and fzf 
function nvim-open
  nvim (fzf --preview 'bat --style=numbers --color=always {}')
end

# Preview in bat with fzf
function bat-preview
  fzf --preview 'bat --style=numbers --color=always {}'
end

