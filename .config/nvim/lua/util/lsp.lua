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

--- Format buffer bằng LSP, bỏ qua các client không nên format.
---@param bufnr integer?
function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    timeout_ms = 3000,
    filter = function(client)
      -- eslint/golangci-lint chỉ là diagnostics, để chúng format sẽ đá nhau
      -- với formatter thật (gopls, rust-analyzer, prettier).
      return client.name ~= "golangci_lint_ls" and client.name ~= "eslint"
    end,
  })
end

return M
