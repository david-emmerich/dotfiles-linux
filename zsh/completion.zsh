# ==============================================================================
# Completion Configuration
# ==============================================================================

# Initialize completion system
autoload -Uz compinit && compinit -C

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu selection
zstyle ':completion:*' menu select

# Cache for completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# Colors in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Verbose completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
