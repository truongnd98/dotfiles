-- Helpers dùng chung cho format-on-save của Go / Rust.
local M = {}

--- Chạy code action `source.organizeImports` một cách đồng bộ.
---
--- Bắt buộc phải sync: nếu chạy async trong `BufWritePre` thì file đã được ghi
--- xuống đĩa xong trước khi edit của LSP kịp áp vào buffer, dẫn tới file trên
--- đĩa thiếu import trong khi buffer lại "modified".
---
---@param bufnr integer?
---@param timeout_ms integer?
function M.organize_imports(bufnr, timeout_ms)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  timeout_ms = timeout_ms or 1000

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
  for _, client in ipairs(clients) do
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
      -- `source.organizeImports` áp cho cả file, range chỉ để thoả schema.
      range = {
        start = { line = 0, character = 0 },
        ["end"] = { line = 0, character = 0 },
      },
      context = { only = { "source.organizeImports" }, diagnostics = {} },
    }

    local ok, res = pcall(client.request_sync, client, "textDocument/codeAction", params, timeout_ms, bufnr)
    if ok and res and not res.err and res.result then
      for _, action in ipairs(res.result) do
        -- Code action có thể trả về `edit`, `command`, hoặc cả hai.
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end
        if action.command then
          local command = type(action.command) == "table" and action.command or action
          client:exec_cmd(command, { bufnr = bufnr })
        end
      end
    end
  end
end

-- ---------------------------------------------------------------------------
-- Chọn formatter khi một buffer có NHIỀU client cùng format được
-- ---------------------------------------------------------------------------
-- Rõ nhất là TS/JS: cả `null-ls` (prettier) và `tsc` (LSP native của
-- TypeScript 7) đều khai `documentFormattingProvider`. Không chọn thì cả hai
-- cùng chạy và kết quả phụ thuộc thứ tự attach - tức là không xác định.
--
--   null-ls (prettier)  opinionated: thêm `;`, tách `{ return a }` thành nhiều
--                       dòng, chuẩn hoá quote. Cần `prettier` (Mason) và
--                       plugins/none-ls.lua đang bật.
--   tsc                 formatter của chính tsserver: chỉ sửa khoảng trắng và
--                       indent, KHÔNG thêm `;`, KHÔNG tách dòng.
--
-- ===> BẬT/TẮT: sửa giá trị trong bảng `M.prefer` ngay dưới đây.
--
--        "null-ls"  -> dùng prettier          (đang đặt)
--        "tsc"      -> dùng formatter của tsc
--        nil        -> bỏ chọn, để mọi client format lần lượt (không khuyến
--                      khích: hai formatter sẽ ghi đè lẫn nhau)
--
--      Xoá cả dòng cũng tương đương `nil`. Với Go/Rust không cần đặt gì: sau
--      khi loại `golangci_lint_ls` thì mỗi ngôn ngữ chỉ còn đúng một formatter
--      (gopls, rust-analyzer).
--
-- Kiểm tra client nào đang thắng ở buffer hiện tại: `:FormatInfo`.
M.prefer = {
  typescript = "null-ls",
  typescriptreact = "null-ls",
  javascript = "null-ls",
  javascriptreact = "null-ls",
  json = "null-ls",
  yaml = "null-ls",
  markdown = "null-ls",
}

-- Client chỉ làm diagnostics. Để chúng format sẽ đá nhau với formatter thật.
M.never_format = {
  golangci_lint_ls = true,
  eslint = true,
}

--- Client nào sẽ thực sự format buffer này.
---@param bufnr integer?
---@return string[] use      tên các client sẽ được dùng
---@return string? unavailable  client trong `M.prefer` nhưng không attach
function M.formatters(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local eligible = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })) do
    if not M.never_format[client.name] then
      eligible[#eligible + 1] = client.name
    end
  end

  local want = M.prefer[vim.bo[bufnr].filetype]
  if not want then
    return eligible, nil
  end
  if vim.tbl_contains(eligible, want) then
    return { want }, nil
  end

  -- `want` được đặt nhưng không attach: tắt none-ls, project chưa có
  -- `typescript` >= 7, prettier chưa cài... Fallback về client còn lại thay vì
  -- im lặng không format gì - lỗi im lặng kiểu đó rất khó nhận ra.
  return eligible, want
end

--- Format buffer bằng LSP.
---@param bufnr integer?
function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local allow = {}
  for _, name in ipairs(M.formatters(bufnr)) do
    allow[name] = true
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    timeout_ms = 3000,
    filter = function(client)
      return allow[client.name] == true
    end,
  })
end

return M
