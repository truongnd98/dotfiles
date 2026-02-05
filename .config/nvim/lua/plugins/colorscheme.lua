return {
  -- {
  --   "baliestri/aura-theme"},
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
  --     vim.cmd([[colorscheme aura-dark]])
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  --   end,
  -- },
  {
    "ray-x/aurora",
    init = function()
      vim.g.aurora_italic = 1
      vim.g.aurora_transparent = 1
      vim.g.aurora_bold = 1
    end,
    config = function()
      vim.cmd.colorscheme "aurora"
      -- override defaults
      vim.api.nvim_set_hl(0, "@number", { fg = "#e933e3" })

      -- Visual mode selection highlight
      vim.api.nvim_set_hl(0, "Visual", { bg = "#44475a", reverse = true })
      vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#44475a", reverse = true })
    end
  }
}
