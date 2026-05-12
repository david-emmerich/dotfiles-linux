-- ==============================================================================
-- Neovim Options
-- ==============================================================================

local opt = vim.opt

-- UI
opt.cmdheight = 1 -- Show command line (needed to avoid forced popups)
opt.showtabline = 0 -- Never show tabline
opt.confirm = false -- Don't confirm on unsaved changes
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight current line
opt.relativenumber = true -- Relative line numbers
opt.number = true -- Show current line number
opt.wrap = false -- Don't wrap lines
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- Editing
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indent width
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart indentation
opt.autoindent = true -- Copy indent from current line

-- Search
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Case-sensitive if uppercase in search
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Performance
opt.updatetime = 250 -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence completion
opt.redrawtime = 1500 -- Time for highlighting

-- Splits
opt.splitbelow = true -- Horizontal split below
opt.splitright = true -- Vertical split right

-- Misc
opt.hidden = true -- Keep hidden buffers
opt.mouse = "a" -- Enable mouse
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.undofile = true -- Persistent undo
opt.termguicolors = true -- True color support
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Disable nvim intro
opt.shortmess:append({ I = true })

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
