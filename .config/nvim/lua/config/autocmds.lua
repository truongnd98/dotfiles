local im = require "util.im"
-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})

vim.api.nvim_create_augroup("IMSwitchHandler", { clear = true })

vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
  pattern = "[/?]",
  -- pattern = "[:/?]",
  callback = function() im.offIM() end,
  group = "IMSwitchHandler"
})

vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
  pattern = "[/?]",
  -- pattern = "[:/?]",
  callback = function() im.offIM() end,
  group = "IMSwitchHandler"
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function() im.offIM() end,
  group = "IMSwitchHandler"
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = "*",
  callback = function() im.offIM() end,
  group = "IMSwitchHandler"
})

im.offIM()
