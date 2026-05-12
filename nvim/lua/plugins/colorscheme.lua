-- ==============================================================================
-- Colorscheme: github_dark_dimmed (standalone, no LazyVim)
-- ==============================================================================

return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    main = "github-theme",
    opts = {
      groups = {
        github_dark_dimmed = {
          SnacksIndent = { fg = "#2d333b" },
          SnacksIndentScope = { fg = "#adbac7" },
          Function = { fg = "#FFFFFF" },
          Variable = { fg = "#4B818E" },
          Identifier = { fg = "#FFFFFF" },
          Directory = { fg = "#FFFFFF" },
          ["@variable"] = { fg = "#ffffff" },
          ["@variable.member"] = { fg = "#6cb6ff" },
          ["@property"] = { fg = "#00ff00" },
          ["@variable.parameter"] = { fg = "#dcba74" },
        },
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd("colorscheme github_dark_dimmed")
    end,
  },
}
