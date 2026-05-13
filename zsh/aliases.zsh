# ==============================================================================
# Aliases
# ==============================================================================

# Navigation
alias l="ls -AGhF"
alias ll="ls -lAGhF"
alias la="ls -AGhF"
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
