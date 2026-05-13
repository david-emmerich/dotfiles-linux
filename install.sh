#!/bin/bash

# ==============================================================================
# Dotfiles Linux Install Script
# ==============================================================================
# Usage:
#   ./install.sh          Install dotfiles (symlinks, zsh plugins, tmux/TPM)
#   ./install.sh --clean  Remove everything (symlinks, plugins, caches)
#
# Prerequisites (installed by Ansible):
#   apt: tmux, git, fzf, ripgrep, fd-find, curl, zsh, gcc
#   binaries: nvim, starship (→ ~/.local/bin)
#
# This script only handles: symlinks, zsh plugins, TPM, tmux plugin install.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$HOME/.dotfiles"
CLEAN=false

for arg in "$@"; do
  case $arg in
    --clean) CLEAN=true ;;
    *)
      echo -e "${RED}Unknown option: $arg${NC}"
      echo "Usage: ./install.sh [--clean]"
      exit 1
      ;;
  esac
done

# ==============================================================================
# --clean: Remove everything
# ==============================================================================

if [[ "$CLEAN" == true ]]; then
  echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║          Cleaning all dotfiles                ║${NC}"
  echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
  echo ""

  echo -e "${YELLOW}[1/3] Removing symlinks...${NC}"
  for link in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.config/nvim" "$HOME/.config/starship.toml"; do
    if [[ -L "$link" ]]; then
      rm "$link"
      echo -e "  ${GREEN}✓ removed symlink: $link${NC}"
    fi
  done

  echo -e "${YELLOW}[2/3] Removing zsh plugins...${NC}"
  rm -rf "$DOTFILES_DIR/zsh/plugins"
  echo -e "  ${GREEN}✓ zsh plugins removed${NC}"

  echo -e "${YELLOW}[3/3] Removing tmux plugins...${NC}"
  rm -rf "$HOME/.tmux"
  echo -e "  ${GREEN}✓ tmux plugins removed${NC}"

  echo ""
  echo -e "${GREEN}Clean complete!${NC}"
  echo -e "${YELLOW}Remaining:${NC}"
  echo "  • $DOTFILES_DIR/ (repo itself — delete manually if needed)"
  echo "  • apt packages — remove with: sudo apt purge tmux fzf ripgrep fd-find zsh"
  echo "  • binaries in ~/.local/bin (nvim, starship) — remove manually"
  echo ""
  exit 0
fi

# ==============================================================================
# Normal installation
# ==============================================================================

echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Dotfiles Installation                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo -e "${RED}Error: $DOTFILES_DIR not found.${NC}"
  echo "Please clone the repository first:"
  echo "  git clone <repo-url> ~/.dotfiles"
  exit 1
fi

cd "$DOTFILES_DIR"

# ------------------------------------------------------------------------------
# [1/4] Create symlinks
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[1/4] Creating symlinks...${NC}"

backup_if_exists() {
  if [[ -e "$1" && ! -L "$1" ]]; then
    mv "$1" "$1.backup.$(date +%Y%m%d%H%M%S)"
    echo -e "  ${YELLOW}Backed up: $1${NC}"
  fi
}

mkdir -p "$HOME/.config"

backup_if_exists "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
echo -e "  ${GREEN}✓ ~/.zshrc${NC}"

backup_if_exists "$HOME/.config/starship.toml"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
echo -e "  ${GREEN}✓ ~/.config/starship.toml${NC}"

backup_if_exists "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo -e "  ${GREEN}✓ ~/.tmux.conf${NC}"

backup_if_exists "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
echo -e "  ${GREEN}✓ ~/.config/nvim${NC}"

# ------------------------------------------------------------------------------
# [2/4] Install Zsh plugins
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[2/4] Installing Zsh plugins...${NC}"

ZSH_PLUGINS_DIR="$DOTFILES_DIR/zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

clone_plugin() {
  local name="$1" url="$2"
  if [[ ! -d "$ZSH_PLUGINS_DIR/$name" ]]; then
    git clone --depth=1 "$url" "$ZSH_PLUGINS_DIR/$name"
    echo -e "  ${GREEN}✓ $name${NC}"
  else
    echo -e "  ${GREEN}✓ $name (already installed)${NC}"
  fi
}

clone_plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
clone_plugin zsh-autopair            https://github.com/hlissner/zsh-autopair

# Oh-My-Zsh vi-mode (single file)
OH_MY_ZSH_VI_DIR="$ZSH_PLUGINS_DIR/oh-my-zsh-vi-mode"
if [[ ! -f "$OH_MY_ZSH_VI_DIR/vi-mode.plugin.zsh" ]]; then
  mkdir -p "$OH_MY_ZSH_VI_DIR"
  curl -sL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/vi-mode/vi-mode.plugin.zsh" \
    -o "$OH_MY_ZSH_VI_DIR/vi-mode.plugin.zsh"
  echo -e "  ${GREEN}✓ oh-my-zsh-vi-mode${NC}"
else
  echo -e "  ${GREEN}✓ oh-my-zsh-vi-mode (already installed)${NC}"
fi

# ------------------------------------------------------------------------------
# [3/4] Install TPM (Tmux Plugin Manager)
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[3/4] Installing TPM...${NC}"

TPM_DIR="$HOME/.tmux/plugins/tpm"
mkdir -p "$HOME/.tmux/plugins"

if [[ ! -d "$TPM_DIR" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo -e "  ${GREEN}✓ TPM installed${NC}"
else
  echo -e "  ${GREEN}✓ TPM (already installed)${NC}"
fi

# ------------------------------------------------------------------------------
# [4/4] Install Tmux plugins
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[4/4] Installing Tmux plugins...${NC}"

if [[ -x "$TPM_DIR/bin/install_plugins" ]]; then
  TMUX_TMPDIR=/tmp "$TPM_DIR/bin/install_plugins" 2>/dev/null \
    && echo -e "  ${GREEN}✓ Tmux plugins installed${NC}" \
    || echo -e "  ${YELLOW}Run 'prefix + I' in tmux to install plugins${NC}"
else
  echo -e "  ${YELLOW}Run '~/.tmux/plugins/tpm/bin/install_plugins' or 'prefix + I' in tmux${NC}"
fi

# ------------------------------------------------------------------------------
# Done!
# ------------------------------------------------------------------------------

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Installation Complete!              ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "  1. Restart your shell or run:"
echo -e "     ${YELLOW}source ~/.zshrc${NC}"
echo ""
echo "  2. Install Neovim plugins (first time):"
echo -e "     ${YELLOW}nvim --headless +Lazy! sync +qa${NC}"
echo ""
echo "  3. In tmux, press 'prefix + I' to install plugins"
echo ""
