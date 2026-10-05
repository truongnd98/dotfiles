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
