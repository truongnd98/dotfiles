return {
  "baliestri/aura-theme",
  lazy = false,
  priority = 1000,
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    vim.cmd([[colorscheme aura-dark]])
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  end,
}
