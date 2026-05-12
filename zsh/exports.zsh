# ==============================================================================
# Environment Variables & PATH
# ==============================================================================

# User-local binaries (starship, nvim, fd, …)
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (macOS only)
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# OpenJDK (if installed via Homebrew)
if [[ -d /opt/homebrew/opt/openjdk/bin ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi

# Default Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Less options
export LESS="-R -F -X"

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
