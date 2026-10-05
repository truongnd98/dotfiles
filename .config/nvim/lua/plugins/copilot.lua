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
      -- Ẩn ghost text của Copilot khi menu blink.cmp đang mở: nếu để `false`,
      -- gợi ý Copilot và danh sách completion vẽ đè lên nhau.
      hide_during_completion = true,
      debounce = 250,
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
      -- Key đúng là `type` (trước đây viết `types` nên bị bỏ qua); dùng binary
      -- của copilot-language-server thay vì chạy qua Node.
      type = "binary",
    },
    server_opts_overrides = {
      trace = "off",
    },
  },
}
