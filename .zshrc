# Skip variable checks for significant speedup
skip_global_compinit=1
DISABLE_COMPFIX=true

# Enable zsh profiling
zmodload zsh/zprof

# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/nicola.bertelloni/.zsh/completions:"* ]]; then export FPATH="/Users/nicola.bertelloni/.zsh/completions:$FPATH"; fi

# Check if shell is interactive
if [[ $- == *i* ]]; then
    # Initialize starship prompt for interactive sessions
    eval "$(starship init zsh)"
fi

# Load essential configs first
source ~/.config/zsh/exports.sh

# Interactive shell configurations
if [[ $- == *i* ]]; then
    # Load EXTREME SPEED config (previous config saved as zsh-config-optimized.sh)
    # source ~/.config/zsh/zsh-extreme-speed.sh
    source ~/.config/zsh/zsh-config.sh

    # Load lazily-loaded configs
    # source ~/.config/zsh/nvm-config.sh
    eval "$(fnm env --use-on-cd --shell zsh)"
    # source ~/.config/zsh/conda.sh
    source ~/.config/zsh/pnpm-config.sh

    # Load the rest of the configs
    # source ~/.config/zsh/window-rename.sh
    source ~/.config/zsh/omz-git-aliases.sh
    source ~/.config/zsh/custom-aliases.sh
fi

# Always load secrets (needed for both interactive and non-interactive sessions)
source ~/.config/zsh/secrets.sh

# p10k configuration has been backed up to ~/.config/zsh/p10k.zsh.backup
# . "/Users/nicola.bertelloni/.deno/env"

# opencode
export PATH=/Users/nicola.bertelloni/.opencode/bin:$PATH

# Show profiling results
# zprof

