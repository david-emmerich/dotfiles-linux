# ==============================================================================
# Zsh Configuration
# ==============================================================================
# Main config file - sources modular components
# Symlink this to ~/.zshrc

# Dotfiles directory (auto-detected)
export DOTFILES="${DOTFILES:-$HOME/.dotfiles-linux}"

# ------------------------------------------------------------------------------
# Modules
# ------------------------------------------------------------------------------

source "$DOTFILES/zsh/exports.zsh"
source "$DOTFILES/zsh/options.zsh"
source "$DOTFILES/zsh/completion.zsh"
source "$DOTFILES/zsh/aliases.zsh"

# ------------------------------------------------------------------------------
# Plugins
# ------------------------------------------------------------------------------

# zsh-autosuggestions (gray suggestions from history)
source "$DOTFILES/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting (colors commands as you type)
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-autopair (auto-close brackets, quotes, etc.)
source "$DOTFILES/zsh/plugins/zsh-autopair/zsh-autopair.plugin.zsh"

# Oh-My-Zsh vi-mode (vi-style editing with cursor shape support)
source "$DOTFILES/zsh/plugins/oh-my-zsh-vi-mode/vi-mode.plugin.zsh"

# Custom keybindings and features (jk escape, etc.)
source "$DOTFILES/zsh/keybindings.zsh"

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------

eval "$(starship init zsh)"

# ------------------------------------------------------------------------------
# Local Overrides
# ------------------------------------------------------------------------------

# Load local config if it exists (machine-specific, not in git)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Ensure ~/.local/bin is on PATH (for nvim, starship, fd)
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
