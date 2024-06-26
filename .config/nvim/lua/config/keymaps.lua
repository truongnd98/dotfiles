local discipline = require("craftzdog.discipline")

discipline.cowboy()

local keymap = vim.keymap

local opts = { noremap = true, silent = true }

-- -- Do things without affecting the registers
-- keymap.set("n", "x", '"_x')
-- keymap.set("n", "<Leader>p", '"0p')
-- keymap.set("n", "<Leader>P", '"0P')
-- keymap.set("v", "<Leader>p", '"0p')
-- keymap.set("n", "<Leader>c", '"_c')
-- keymap.set("n", "<Leader>C", '"_C')
-- keymap.set("v", "<Leader>c", '"_c')
-- keymap.set("v", "<Leader>C", '"_C')
-- keymap.set("n", "<Leader>d", '"_d')
-- keymap.set("n", "<Leader>D", '"_D')
-- keymap.set("v", "<Leader>d", '"_d')
-- keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "sd", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
	require("craftzdog.hsl").replaceHexWithHSL()
end)

keymap.set("n", "<leader>i", function()
	require("craftzdog.lsp").toggleInlayHints()
end)

-- Commenting
local function run_func_with_delay(fn, delay, ...)
	local args = { ... }
	local timer = vim.loop.new_timer()
	timer:start(
		delay,
		0,
		vim.schedule_wrap(function()
			fn(unpack(args))
			timer:stop()
			timer:close()
		end)
	)
end

local un_cursor_state = function(current_cursor, line_current)
	local row, col = unpack(current_cursor)
	local line_after = vim.api.nvim_get_current_line()
	local alpha = #line_after - #line_current

	local next_col = col + alpha
	if next_col < 0 then
		return
	end

	vim.api.nvim_win_set_cursor(0, { row, next_col })
end

local toggle_cmt = function()
	local vim_mode = vim.api.nvim_get_mode()
	if vim_mode.blocking == true then
		return
	end

	local current_line = vim.api.nvim_get_current_line()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	run_func_with_delay(un_cursor_state, 0, current_cursor, current_line)

	return require("vim._comment").operator() .. "_"
end

local i_mode_toggle_cmt = function()
	local vim_mode = vim.api.nvim_get_mode()
	if vim_mode.blocking == true then
		return
	end

	local current_line = vim.api.nvim_get_current_line()
	local current_cursor = vim.api.nvim_win_get_cursor(0)
	run_func_with_delay(un_cursor_state, 0, current_cursor, current_line)

	vim.cmd("normal gcc")
end

keymap.set({ "n" }, "gc", toggle_cmt, { expr = true, nowait = true, desc = "Toggle comment line" })
-- keymap.set({ "n", "v" }, "c", toggle_cmt, { expr = true, desc = "Toggle comment line" })
-- keymap.set({ "n", "v" }, "<D-/>", toggle_cmt, { expr = true, desc = "Toggle comment line" }) -- Command + /
-- keymap.set("i", "<D-/>", i_mode_toggle_cmt, { desc = "Toggle comment line" }) -- Command + /
keymap.set({ "n", "v" }, "<C-/>", toggle_cmt, { expr = true, desc = "Toggle comment line" }) -- Control + /
keymap.set("i", "<C-/>", i_mode_toggle_cmt, { desc = "Toggle comment line" }) -- Control + /

-- Terminal
local lazyterm = function()
	LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
keymap.set("n", "<C-t>", lazyterm, { desc = "Terminal (Root Dir)" })
keymap.set("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- Coppy/Paste
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true })
vim.api.nvim_set_keymap("n", "<C-v>", '"+P', { noremap = true })
vim.api.nvim_set_keymap("v", "<C-v>", '"+P', { noremap = true })
vim.api.nvim_set_keymap("c", "<C-v>", "<C-R>+", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-v>", "<C-R>+", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-v>", '<C-\\><C-n>"+Pi', { noremap = true })
