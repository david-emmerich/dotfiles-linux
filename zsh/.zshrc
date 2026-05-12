# ==============================================================================
# Zsh Configuration
# ==============================================================================
# Main config file - sources modular components
# Symlink this to ~/.zshrc

# Dotfiles directory (auto-detected)
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

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

# ------------------------------------------------------------------------------
# Third-Party Completions
# ------------------------------------------------------------------------------

# OpenClaw completion (optional, only if OpenClaw is installed)
if command -v openclaw >/dev/null 2>&1 && [[ -f "$HOME/.openclaw/completions/openclaw.zsh" ]]; then
  source "$HOME/.openclaw/completions/openclaw.zsh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2026-04-28 20:09:47
export PATH="$PATH:/Users/david/.local/bin"
