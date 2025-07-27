return {
  "lewis6991/gitsigns.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    signs = {
      add = { text = "▎" },
      -- change = { text = "∼" },
      change = { text = "▎" },
      delete = { text = "▁" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "~" },
    },
    signs_staged = {
      add = { text = "▎" },
      -- change = { text = "∼" },
      change = { text = "▎" },
      delete = { text = "▁" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "~" },
    },
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
    },
  },
}
