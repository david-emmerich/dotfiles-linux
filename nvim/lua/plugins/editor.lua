-- ==============================================================================
-- Editor Plugins (standalone, no LazyVim)
-- ==============================================================================

return {
  -- WinShift - move splits around
  {
    "sindrets/winshift.nvim",
    cmd = "WinShift",
  },

  -- ToggleTerm - integrated terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = {
      { "<c-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
    },
  },

  -- WhichKey - keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
}
