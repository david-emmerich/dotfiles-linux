#!/bin/bash

# ==============================================================================
# Dotfiles Linux Install Script
# ==============================================================================
# Usage:
#   ./install.sh              Install everything
#   ./install.sh --skip-nvim  Skip neovim installation
#   ./install.sh --clean      Remove everything (configs, programs, caches)
#
# Installs: nvim (minimal config), starship, zsh, tmux
# No LazyVim, no Treesitter, no LSP — pure Lua plugins only.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOTFILES_DIR="$HOME/.dotfiles-linux"
SKIP_NVIM=false
CLEAN=false

for arg in "$@"; do
  case $arg in
    --skip-nvim) SKIP_NVIM=true ;;
    --clean)     CLEAN=true ;;
    *)
      echo -e "${RED}Unknown option: $arg${NC}"
      echo "Usage: ./install.sh [--skip-nvim] [--clean]"
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

  # --- Symlinks ---
  echo -e "${YELLOW}[1/5] Removing symlinks...${NC}"
  for link in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.config/nvim" "$HOME/.config/starship.toml"; do
    if [[ -L "$link" ]]; then
      rm "$link"
      echo -e "  ${GREEN}✓ removed symlink: $link${NC}"
    fi
  done

  # --- Backup files ---
  echo -e "${YELLOW}[2/5] Removing backup files...${NC}"
  find "$HOME" -maxdepth 1 -name "*.backup.*" -delete 2>/dev/null && \
    echo -e "  ${GREEN}✓ removed ~/.*.backup.* files${NC}" || \
    echo -e "  ${GREEN}✓ no backups found${NC}"

  # --- Neovim ---
  echo -e "${YELLOW}[3/5] Removing neovim...${NC}"
  rm -f "$HOME/.local/bin/nvim"
  rm -rf "$HOME/.local/share/nvim"
  rm -rf "$HOME/.local/state/nvim"
  rm -rf "$HOME/.cache/nvim"
  rm -rf "$HOME/.local/lib/nvim"
  echo -e "  ${GREEN}✓ neovim removed${NC}"

  # --- Starship ---
  echo -e "${YELLOW}[4/5] Removing starship...${NC}"
  rm -f "$HOME/.local/bin/starship"
  echo -e "  ${GREEN}✓ starship removed${NC}"

  # --- Tmux plugins ---
  echo -e "${YELLOW}[5/5] Removing tmux plugins...${NC}"
  rm -rf "$HOME/.tmux"
  echo -e "  ${GREEN}✓ tmux plugins removed${NC}"

  # --- Summary ---
  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║           Clean complete!                     ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}Remaining:${NC}"
  echo "  • ~/.dotfiles-linux/ (repo itself — delete manually if needed)"
  echo "  • apt packages (tmux, git, fzf, ripgrep, fd-find, zsh, gcc)"
  echo "    → remove with: sudo apt purge tmux fzf ripgrep fd-find zsh"
  echo ""
  exit 0
fi

# ==============================================================================
# Normal installation
# ==============================================================================

echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║       Dotfiles Linux Installation            ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo -e "${RED}Error: $DOTFILES_DIR not found.${NC}"
  echo "Please clone the repository first:"
  echo "  git clone <repo-url> ~/.dotfiles-linux"
  exit 1
fi

cd "$DOTFILES_DIR"

# ------------------------------------------------------------------------------
# [1/6] Install packages via apt
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[1/6] Installing packages via apt...${NC}"

APT_PACKAGES=(tmux git fzf ripgrep fd-find curl zsh gcc)

sudo apt-get update -qq
sudo apt-get install -y "${APT_PACKAGES[@]}"
echo -e "  ${GREEN}✓ apt packages installed${NC}"

# ------------------------------------------------------------------------------
# [2/6] Install Neovim + Starship from GitHub
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[2/6] Installing binaries...${NC}"

mkdir -p "$HOME/.local/bin"

# Neovim
if [[ "$SKIP_NVIM" == false ]]; then
  NVIM_BIN="$HOME/.local/bin/nvim"
  NVIM_LATEST=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
  NVIM_CURRENT=$( "$NVIM_BIN" --version 2>/dev/null | head -1 | grep -o 'v[0-9.]*' || echo "none" )

  if [[ "$NVIM_CURRENT" == "$NVIM_LATEST" ]]; then
    echo -e "  ${GREEN}✓ neovim $NVIM_LATEST (already installed)${NC}"
  else
    echo -e "  ${YELLOW}Installing neovim $NVIM_LATEST...${NC}"
    TMP=$(mktemp -d)
    curl -sL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" \
      | tar -xz -C "$TMP"
    cp -r "$TMP"/nvim-linux-x86_64/* "$HOME/.local/"
    rm -rf "$TMP"
    echo -e "  ${GREEN}✓ neovim $NVIM_LATEST → $HOME/.local/bin/nvim${NC}"
  fi
fi

# fd-find: 'fdfind' on Debian/Ubuntu, create 'fd' symlink
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  echo -e "  ${GREEN}✓ fd symlink → $HOME/.local/bin/fd${NC}"
fi

# Starship
if ! command -v starship &>/dev/null && [[ ! -x "$HOME/.local/bin/starship" ]]; then
  echo -e "  ${YELLOW}Installing starship...${NC}"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
  echo -e "  ${GREEN}✓ starship → $HOME/.local/bin/starship${NC}"
else
  echo -e "  ${GREEN}✓ starship (already installed)${NC}"
fi

# Ensure PATH for verification
export PATH="$HOME/.local/bin:$PATH"

# Verify
REQUIRED_TOOLS=(starship tmux git fzf rg)
[[ "$SKIP_NVIM" == false ]] && REQUIRED_TOOLS+=(nvim)
MISSING=()
for tool in "${REQUIRED_TOOLS[@]}"; do
  command -v "$tool" &>/dev/null || MISSING+=("$tool")
done
if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo -e "${RED}Still missing after install: ${MISSING[*]}${NC}"
  exit 1
fi

# ------------------------------------------------------------------------------
# [3/6] Install Zsh plugins
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[3/6] Installing Zsh plugins...${NC}"

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
# [4/6] Install TPM (Tmux Plugin Manager)
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[4/6] Installing TPM...${NC}"

TPM_DIR="$HOME/.tmux/plugins/tpm"
mkdir -p "$HOME/.tmux/plugins"

if [[ ! -d "$TPM_DIR" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo -e "  ${GREEN}✓ TPM installed${NC}"
else
  echo -e "  ${GREEN}✓ TPM (already installed)${NC}"
fi

# ------------------------------------------------------------------------------
# [5/6] Create symlinks
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[5/6] Creating symlinks...${NC}"

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

if [[ "$SKIP_NVIM" == false ]]; then
  backup_if_exists "$HOME/.config/nvim"
  ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  echo -e "  ${GREEN}✓ ~/.config/nvim${NC}"
else
  echo -e "  ${YELLOW}~/.config/nvim skipped (--skip-nvim)${NC}"
fi

# ------------------------------------------------------------------------------
# [6/6] Install Tmux plugins
# ------------------------------------------------------------------------------

echo -e "${YELLOW}[6/6] Installing Tmux plugins...${NC}"

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
echo -e "${BLUE}Installed:${NC}"
echo "  • Starship prompt"
echo "  • Zsh with 4 plugins"
echo "  • Tmux with TPM"
echo "  • Neovim (minimal: Snacks, ToggleTerm, WinShift, WhichKey, mini.surround)"
echo ""
echo -e "${YELLOW}Note: No Treesitter, no LSP — pure Lua only.${NC}"
echo ""
