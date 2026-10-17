-- ---------------------------------------------------------------------------
-- Go: tab thật, hiển thị rộng 4 cột
-- ---------------------------------------------------------------------------
-- `ftplugin/go.vim` của Neovim đã đặt `noexpandtab shiftwidth=0 softtabstop=0`
-- (shiftwidth=0 nghĩa là lấy theo tabstop), nhưng không đặt `tabstop` nên nó
-- rơi về giá trị global = 2, khiến code Go hiển thị thụt lề chật hơn gofmt.
-- Rust không cần xử lý: `ftplugin/rust.vim` đã đặt sẵn `sw=4 sts=4 expandtab`.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lang.indent", { clear = true }),
  pattern = { "go", "gomod", "gowork", "gotmpl" },
  callback = function(ev)
    vim.bo[ev.buf].tabstop = 4
  end,
})

-- ---------------------------------------------------------------------------
-- Spell check: chỉ cho văn bản, không cho code
-- ---------------------------------------------------------------------------
-- `vim.opt.spell = true` global tốn ~17ms startup (nạp spell file) và gạch đỏ
-- mọi identifier trong code. Chỉ bật ở nơi nó thật sự có ích.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ui.spell", { clear = true }),
  pattern = { "markdown", "mdx", "gitcommit", "gitrebase", "text", "tex", "typst" },
  callback = function()
    -- `spell` là option window-local (không phải buffer-local) nên phải dùng
    -- opt_local / wo, `vim.bo[...].spell` sẽ ném E5108.
    vim.opt_local.spell = true
    -- Không gạch đỏ URL / từ trong code block.
    vim.opt_local.spelloptions:append("noplainbuffer")
  end,
})

-- ---------------------------------------------------------------------------
-- Format on save cho Go / Rust
-- ---------------------------------------------------------------------------
-- Chỉ bật cho 2 ngôn ngữ này vì cả hai đều có đúng một formatter chính chủ,
-- không tranh chấp (gofumpt qua gopls, rustfmt qua rust-analyzer) - khác với
-- JS/TS nơi prettier/eslint/biome hay đá nhau.
--
-- Với Go còn phải chạy `source.organizeImports` trước: gopls KHÔNG tự bỏ
-- import thừa / thêm import thiếu khi format, mà import sai thì Go không build.
--
-- Tắt tạm: `:FormatToggle` (toàn cục) hoặc `:FormatToggle!` (chỉ buffer này).
vim.g.format_on_save = true

local function should_format(bufnr)
  local buf_setting = vim.b[bufnr].format_on_save
  if buf_setting ~= nil then
    return buf_setting
  end
  return vim.g.format_on_save
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("lang.format_on_save", { clear = true }),
  pattern = { "*.go", "*.rs", "go.mod", "go.work" },
  callback = function(ev)
    if not should_format(ev.buf) then
      return
    end
    if vim.bo[ev.buf].filetype == "go" then
      require("util.lsp").organize_imports(ev.buf)
    end
    require("util.lsp").format(ev.buf)
  end,
})

vim.api.nvim_create_user_command("FormatToggle", function(cmd)
  if cmd.bang then
    vim.b.format_on_save = not should_format(0)
    vim.notify(("Format on save (buffer): %s"):format(vim.b.format_on_save))
  else
    vim.g.format_on_save = not vim.g.format_on_save
    vim.b.format_on_save = nil
    vim.notify(("Format on save (global): %s"):format(vim.g.format_on_save))
  end
end, { bang = true, desc = "Toggle format on save (! = chỉ buffer hiện tại)" })

-- Buffer này sẽ được format bởi client nào. Dùng khi nghi hai formatter đá
-- nhau (vd TS: prettier qua none-ls vs formatter của tsc) - xem util/lsp.lua.
vim.api.nvim_create_user_command("FormatInfo", function()
  local lsp = require("util.lsp")
  local ft = vim.bo.filetype

  local can = {}
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/formatting" })) do
    can[#can + 1] = c.name
  end

  local use, unavailable = lsp.formatters(0)
  local lines = {
    ("filetype      : %s"):format(ft ~= "" and ft or "(không có)"),
    ("format được   : %s"):format(#can > 0 and table.concat(can, ", ") or "(không client nào)"),
    ("prefer        : %s"):format(lsp.prefer[ft] or "(không đặt -> dùng tất cả)"),
    ("SẼ DÙNG       : %s"):format(#use > 0 and table.concat(use, ", ") or "(không gì cả)"),
  }
  if unavailable then
    lines[#lines + 1] = ("LƯU Ý: prefer đặt `%s` nhưng client đó không attach -> đã fallback."):format(unavailable)
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Client nào sẽ format buffer này" })
