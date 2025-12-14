local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
  "gopls",
  "rust_analyzer",
  "tsserver",
}

for _, s in ipairs(servers) do
  lspconfig[s].setup({
    capabilities = capabilities,
    flags = { debounce_text_changes = 100 },
  })
end
