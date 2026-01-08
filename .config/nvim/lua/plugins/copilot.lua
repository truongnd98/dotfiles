return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "BufReadPost",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      trigger_on_accept = false,
      hide_during_completion = false,
      debounce = 250,
      copilot_suggestion_hidden = true,
      keymap = {
        -- accept = false, -- handled by nvim-cmp / blink.cmp
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
