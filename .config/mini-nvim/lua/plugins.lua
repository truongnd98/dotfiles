local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- blink-cmp (auto-completion siêu nhẹ)
  {
    "Saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
      },
      completion = {
        documentation = { auto_show = true },
      },
      signature = { enabled = true },
    },
  },
})
