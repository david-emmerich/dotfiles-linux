-- ==============================================================================
-- Mini.nvim Plugins (standalone, no LazyVim)
-- ==============================================================================

return {
  -- mini.surround - surround text objects
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },

  -- mini.comment - comment with gcc/gc
  {
    "nvim-mini/mini.comment",
    event = "VeryLazy",
    opts = {},
  },
}
