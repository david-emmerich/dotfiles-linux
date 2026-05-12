-- ==============================================================================
-- Neovim Minimal Config (Linux Server)
-- ==============================================================================
-- No LazyVim, no Treesitter, no LSP — pure Lua plugins only.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("config.options")
require("config.autocmds")
require("config.keymaps")

require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "github_dark_dimmed", "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "netrw",
        "netrwPlugin",
      },
    },
  },
})
