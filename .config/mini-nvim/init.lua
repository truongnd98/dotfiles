require("plugins")
require("lsp")
require("keymaps")

-- basic settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.updatetime = 200

-- disable heavy providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- disable default plugins
local disabled = {
  "gzip", "matchit", "matchparen", "tarPlugin",
  "tohtml", "tutor", "zipPlugin",
}
for _, p in ipairs(disabled) do
  vim.g["loaded_" .. p] = 1
end
