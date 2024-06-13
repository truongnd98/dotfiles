return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    local config = require("tokyonight.config")

    require("tokyonight").setup({
      -- style = "moon",
      on_highlights = function(hl, c)
        hl.Visual = { bg = c.bg_visual, reverse = true } -- Visual mode selection
        hl.VisualNOS = { bg = c.bg_visual, reverse = true } -- Visual mode selection when vim is "Not Owning the Selection".
        hl["@variable"] = { fg = c.yellow, style = config.options.styles.variables }
        hl.DiagnosticUnnecessary = { style = "bold,italic,undercurl", bg = c.none, fg = c.none, sp = c.hint }
      end,
    })

    vim.cmd("colorscheme tokyonight")
  end,
}
