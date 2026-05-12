# ==============================================================================
# Custom Keybindings
# ==============================================================================

# jk as escape (no timeout - immediate)
function _jk_insert_j() {
  zle self-insert
}

function _jk_escape() {
  local char_before_cursor="${BUFFER:$((CURSOR-1)):1}"

  if [[ "$char_before_cursor" == "j" ]]; then
    # Remove the 'j' and switch to normal mode
    BUFFER="${BUFFER:0:$((CURSOR-1))}${BUFFER:$CURSOR}"
    ((CURSOR--))
    zle vi-cmd-mode
  else
    # Not a jk sequence, just insert 'k'
    zle self-insert
  fi
}

zle -N _jk_insert_j
zle -N _jk_escape

# Bind in insert mode
bindkey -M viins 'j' _jk_insert_j
bindkey -M viins 'k' _jk_escape
