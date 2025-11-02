return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  opts = {
    suggestion = {
      enabled = not vim.g.ai_cmp,
      auto_trigger = true,
      trigger_on_accept = false,
      hide_during_completion = vim.g.ai_cmp,
      copilot_suggestion_hidden = true,
      keymap = {
        -- accept = false, -- handled by nvim-cmp / blink.cmp
        accept = "<leader><cr>",
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
    server = {
      types = "binary",
    },
    server_opts_overrides = {
      trace = "off",
    },
  },
}
