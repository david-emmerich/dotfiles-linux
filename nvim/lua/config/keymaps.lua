-- ==============================================================================
-- Custom Keymaps
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- General
-- ------------------------------------------------------------------------------

-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })

-- ------------------------------------------------------------------------------
-- Snacks Picker
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<leader><tab>", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader><space>", function()
  Snacks.picker.lines()
end, { desc = "Search in buffer" })

vim.keymap.set("n", "<leader><cr>", function()
  Snacks.picker.files()
end, { desc = "Find files" })

-- ------------------------------------------------------------------------------
-- Buffer Navigation
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- ------------------------------------------------------------------------------
-- Splits
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>l", "<cmd>vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>j", "<cmd>split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>z", ":tab split<cr>", { desc = "Fullscreen current split" })

-- Escape terminal mode + window navigation with Ctrl-h/j/k/l
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Window left from terminal" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Window down from terminal" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Window up from terminal" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Window right from terminal" })

-- ------------------------------------------------------------------------------
-- Terminal (ToggleTerm)
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Floating terminal" })
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal size=15<cr>", { desc = "Horizontal terminal" })

-- WinShift - move splits
vim.keymap.set("n", "<S-Up>", "<cmd>WinShift up<cr>", { desc = "Move split up" })
vim.keymap.set("n", "<S-Down>", "<cmd>WinShift down<cr>", { desc = "Move split down" })
vim.keymap.set("n", "<S-Right>", "<cmd>WinShift right<cr>", { desc = "Move split right" })
vim.keymap.set("n", "<S-Left>", "<cmd>WinShift left<cr>", { desc = "Move split left" })

-- ------------------------------------------------------------------------------
-- Comments (using mini.comment via gcc/gc)
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>#", "gcc", { remap = true, desc = "Comment line" })
vim.keymap.set("v", "<leader>#", "gc", { remap = true, desc = "Comment selection" })

-- ------------------------------------------------------------------------------
-- Line Movement
-- ------------------------------------------------------------------------------

vim.keymap.set("n", "<CR>", ":call append(line('.') - 1, '')<cr>", { remap = false, desc = "Insert blank line above" })
vim.keymap.set("n", "<Up>", "ddkP", { desc = "Move line up" })
vim.keymap.set("n", "<Down>", "ddp", { desc = "Move line down" })

-- ------------------------------------------------------------------------------
-- Insert Mode Helpers
-- ------------------------------------------------------------------------------

vim.keymap.set("i", "<C-b>", "\\", { remap = true, desc = "Insert backslash" })
vim.keymap.set("i", "<C-n>", "\\n", { desc = "Insert newline escape" })

-- ------------------------------------------------------------------------------
-- Snacks notify override (route to cmdline, no floating popups)
-- ------------------------------------------------------------------------------

vim.notify = function(msg, level, _opts)
  if msg == nil or msg == "" then
    return
  end
  msg = msg:gsub("\n+$", "")
  local hl = "None"
  level = level or vim.log.levels.INFO
  if level == vim.log.levels.ERROR then
    hl = "ErrorMsg"
  elseif level == vim.log.levels.WARN then
    hl = "WarningMsg"
  end
  vim.api.nvim_echo({ { msg, hl } }, true, {})
end
