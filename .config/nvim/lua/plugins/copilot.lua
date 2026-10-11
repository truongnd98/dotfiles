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
    -- `filetypes` = "ở đâu mình MUỐN gợi ý". Blocklist mặc định của copilot.lua
    -- là yaml/markdown/help/gitcommit/gitrebase/hgcommit/svn/cvs; hai dòng dưới
    -- mở lại markdown + help. `yaml` cố ý để nguyên (bị block) vì manifest k8s /
    -- CI secret hay nằm ở đó.
    filetypes = {
      markdown = true,
      help = true,
    },
    -- `should_attach` = "cái gì TUYỆT ĐỐI không gửi đi". Phải tách riêng vì
    -- `filetypes` không đủ: `.env` có ft `env`, `.npmrc` -> `dosini`,
    -- `key.pem` -> `pem`, còn `id_rsa` và `credentials` thì Nvim không nhận ra
    -- ft nào cả - KHÔNG cái nào nằm trong blocklist mặc định của copilot.
    -- Buffer bị chặn ở đây thì client không attach, tức nội dung file không bao
    -- giờ được gửi lên GitHub.
    should_attach = function(bufnr, bufname)
      -- Giữ lại hai điều kiện của bản default (config/should_attach.lua).
      if not vim.bo[bufnr].buflisted or vim.bo[bufnr].buftype ~= "" then
        return false
      end

      bufname = bufname or ""
      local name = vim.fs.basename(bufname)

      local secret_names = {
        "^%.env",            -- .env, .env.local, .env.production...
        "^%.npmrc$",
        "^%.yarnrc",
        "^%.netrc$",
        "^%.pgpass$",
        "^%.htpasswd$",
        "^credentials$",
        "^authorized_keys$",
        "^id_%w+$",          -- id_rsa, id_ed25519 (private key; .pub không khớp)
        "%.pem$",
        "%.key$",
        "%.p12$",
        "%.pfx$",
        "%.keystore$",
        "%.kdbx$",
      }
      for _, pat in ipairs(secret_names) do
        if name:match(pat) then
          return false
        end
      end

      local secret_dirs = { "/%.ssh/", "/%.gnupg/", "/%.aws/", "/%.kube/" }
      for _, pat in ipairs(secret_dirs) do
        if bufname:match(pat) then
          return false
        end
      end

      return true
    end,
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
