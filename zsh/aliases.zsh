# ==============================================================================
# Aliases
# ==============================================================================

# Navigation
alias l="ls --color=auto -AhF"
alias ll="ls --color=auto -lAhF"
alias la="ls --color=auto -AhF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Directory
alias mkdir="mkdir -p"

# Editor
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Git
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate -20"
alias gd="git diff"

# System
alias clr="clear"
alias reload="source ~/.zshrc && echo 'zsh reloaded!'"
alias zshconfig="$EDITOR ~/.zshrc"

# Sudo: trailing space lets zsh expand aliases on the *next* word too,
# so `sudo v` becomes `sudo nvim` etc.
alias sudo='sudo '

# Route `sudo nvim <file>` (and vim) through sudoedit so the editor runs as
# the invoking user — keeps your nvim config, plugins, and caches intact.
# Falls through to real sudo for everything else (incl. `sudo nvim` without a file).
# Quote the name so zsh doesn't try to alias-expand `sudo` while parsing the def.
'sudo'() {
  if [[ ( "$1" == "nvim" || "$1" == "vim" ) && $# -gt 1 ]]; then
    shift
    SUDO_EDITOR=nvim command sudoedit "$@"
  else
    command sudo "$@"
  fi
}
