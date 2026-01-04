local lspconfig = vim.lsp.config
local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
  "gopls",
  "rust_analyzer",
  "ts_ls",
}

for _, s in ipairs(servers) do
  lspconfig[s] = {
    capabilities = capabilities,
    flags = { debounce_text_changes = 100 },
  }
end
