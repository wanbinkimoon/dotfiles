# Lazy load conda for faster terminal startup
export PATH="/opt/homebrew/anaconda3/bin:$PATH"

# Disable auto-activation of base environment
conda config --set auto_activate_base false &>/dev/null

# Function to initialize conda when needed
conda_init() {
  __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
      . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    fi
  fi
  unset __conda_setup
}

# Create wrapper functions
conda() {
  conda_init
  conda "$@"
}

python() {
  # Check if it's a conda command first
  if [[ "$PATH" == */opt/homebrew/anaconda3/bin* ]]; then
    conda_init
  fi
  command python "$@"
}

# Use 'condaon' to explicitly activate conda
condaon() {
  conda_init
  echo "Conda initialized and ready to use"
}
