-- ==============================================================================
-- Snacks: Picker (standalone, no LazyVim)
-- ==============================================================================
-- Pure Lua — no external dependencies beyond ripgrep for the picker.

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      notifier = { enabled = false },
      dashboard = { enabled = false },
      image = { enabled = false },
      input = { enabled = false },
      picker = {
        formatters = {
          file = { filename_first = true },
        },
        sources = {
          lines = {
            layout = {
              preset = "select",
              layout = {
                width = 0.8,
                min_width = 120,
                height = 0.8,
              },
            },
          },
          buffers = {
            format = function(item)
              return { { vim.fn.fnamemodify(item.file, ":t") } }
            end,
          },
        },
      },
    },
  },
}
