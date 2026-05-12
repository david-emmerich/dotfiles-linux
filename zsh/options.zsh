# ==============================================================================
# Zsh Options
# ==============================================================================

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY        # Append to history file, don't overwrite
setopt SHARE_HISTORY         # Share history across sessions
setopt HIST_IGNORE_DUPS      # Don't record duplicate entries
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks

# Directory
setopt AUTO_CD               # cd by typing directory name
setopt AUTO_PUSHD            # Push old directory to stack
setopt PUSHD_IGNORE_DUPS     # Don't push duplicates

# Completion
setopt AUTO_MENU             # Use menu completion
setopt AUTO_LIST             # List options on ambiguous completion
setopt COMPLETE_IN_WORD      # Complete from cursor position

# Input/Output
setopt CORRECT               # Spelling correction for commands
unsetopt BEEP                # Disable terminal bell

# Zsh-Syntax-Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
