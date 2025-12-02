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
	local _, start_line, start_col, end_line, end_col 
	_, start_line, start_col, _ = unpack(vim.fn.getpos("."))
	_, end_line, end_col, _ = unpack(vim.fn.getpos("v"))

  if start_line ~= end_line then
    return
  end

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

  -- Make sure selection is from left to right
  if start_col > end_col then
    start_col, end_col = end_col, start_col
  end

  -- Get the selected line
  local line = vim.fn.getline(start_line)

  -- Only return the selected range from the first line
  local selected_text = string.sub(line, start_col, end_col)

	selected_text = escape_chars(selected_text)

	local replace_cmd = ":%s/\\C" .. selected_text .. "/" .. selected_text 
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
keymap.set("n", "qn", function ()
  pcall(function ()
    vim.cmd("cnext")
  end)
end, { desc = "Goto previous item quickfix list" })
keymap.set("n", "qp", function ()
  pcall(function ()
    vim.cmd("cpre")
  end)
end, { desc = "Goto previous item quickfix list" })
keymap.set("n", "qf", ":cfirst<cr>", { desc = "Goto first item quickfix list" })

-- Diagnostic
keymap.set("n", "<leader>s", vim.diagnostic.open_float, { desc = "Show diagnostic error" })

-- Remove highlight
keymap.set("n", "<leader>h", "<cmd>noh<cr>", { desc = "Remove highlight" })
