local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete inner word
keymap.set("n", "dw", 'viw"_d')
-- Delete before cursor
keymap.set("n", "ds", 'v^"_d')
-- Delete after cursor
keymap.set("n", "de", 'v$h"_d')

-- Replace text selection
local function tbl_length(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end
local escape_chars = function(string)
	return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
		["\\"] = "\\\\",
		["-"] = "\\-",
		-- ["("] = "\\(",
		-- [")"] = "\\)",
		["["] = "\\[",
		["]"] = "\\]",
		-- ["{"] = "\\{",
		["}"] = "\\}",
		-- ["?"] = "\\?",
		["+"] = "\\+",
		["*"] = "\\*",
		["^"] = "\\^",
		["$"] = "\\$",
		["."] = "\\.",
	})
end
keymap.set("v", "<leader>h", function()
	local _, csrow, cscol, cerow, cecol
	_, csrow, cscol, _ = table.unpack(vim.fn.getpos("."))
	_, cerow, cecol, _ = table.unpack(vim.fn.getpos("v"))

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	local n = tbl_length(lines)
	if n <= 0 then
		return
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)

	local text_selected = table.concat(lines, "\\n")
	local text_replace = table.concat(lines, "\\r")

	text_selected = escape_chars(text_selected)
	text_replace = escape_chars(text_replace)

	local replace_cmd = ":%s/" .. text_selected .. "/" .. text_replace
	vim.api.nvim_feedkeys(replace_cmd, "n", true)
end)

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- -- Jumplist
-- keymap.set("n", "<C-m>", "<C-i>", opts)

-- Split window
keymap.set("n", "sd", ":split", opts)
keymap.set("n", "sv", ":vsplit", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "s<left>", "<C-w>4<")
keymap.set("n", "s<right>", "<C-w>4>")
keymap.set("n", "s<up>", "<C-w>4+")
keymap.set("n", "s<down>", "<C-w>4-")
-- Disable insert key `s`
keymap.set("n", "s", "<nop>")

-- Buffer switch
keymap.set("n", "<C-j>", ":bprevious<cr>")
keymap.set("n", "<C-k>", ":bnext<cr>")
keymap.set("n", "<C-l>", ":blast<cr>")

--Move selected lines
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("n", "K", ":m -2<cr>==")
vim.keymap.set("n", "J", ":m +1<cr>==")

-- Quickfix
local function isQuickfixOpened()
  return 1
end
keymap.set("n", "n", function ()
  if not isQuickfixOpened() then return end
  pcall(function ()
    vim.cmd("cnext")
  end)
end)
keymap.set("n", "N", function ()
  if not isQuickfixOpened() then return end
  pcall(function ()
    vim.cmd("cpre")
  end)
end)
