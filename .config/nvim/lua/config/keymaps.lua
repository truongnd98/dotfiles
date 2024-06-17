-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap` instead
local keymap = Util.safe_keymap_set

local make_opts = function(custom_opts)
  return vim.tbl_extend("force", { noremap = true, silent = true }, custom_opts or {})
end

-- Always insert at the end of the line
keymap("n", "p", "P", make_opts())

-- Config clipboard for Neovide
if vim.g.neovide then
  -- keymap("n", "<D-s>", ":w<CR>", { noremap = true }) -- Save
  vim.api.nvim_set_keymap("v", "<D-c>", '"+y', { noremap = true })
  vim.api.nvim_set_keymap("n", "<D-v>", '"+P', { noremap = true })
  vim.api.nvim_set_keymap("v", "<D-v>", '"+P', { noremap = true })
  vim.api.nvim_set_keymap("c", "<D-v>", "<C-R>+", { noremap = true })
  vim.api.nvim_set_keymap("i", "<D-v>", "<C-R>+", { noremap = true })
  vim.api.nvim_set_keymap("t", "<D-v>", '<C-\\><C-n>"+Pi', { noremap = true })
end

-- Select all
keymap("n", "<D-a>", "gg<S-v>G")

-- Split window
keymap("n", "sd", ":split<Return>", make_opts())
keymap("n", "sv", ":vsplit<Return>", make_opts())
-- Move window
keymap("n", "sh", "<C-w>h", make_opts())
keymap("n", "sk", "<C-w>k", make_opts())
keymap("n", "sj", "<C-w>j", make_opts())
keymap("n", "sl", "<C-w>l", make_opts())

-- Resize window
keymap("n", "s<left>", "<C-w>2<")
keymap("n", "s<right>", "<C-w>2>")
keymap("n", "s<up>", "<C-w>2+")
keymap("n", "s<down>", "<C-w>2-")

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

-- Commenting
local un_cursor_state = function(current_cursor, line_current, mode)
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

keymap({ "n" }, "gc", toggle_cmt, { expr = true, desc = "Toggle comment line" })
keymap({ "n", "v" }, "c", toggle_cmt, { expr = true, desc = "Toggle comment line" })
keymap({ "n", "v" }, "<D-/>", toggle_cmt, { expr = true, desc = "Toggle comment line" }) -- Command + /
keymap("i", "<D-/>", i_mode_toggle_cmt, { desc = "Toggle comment line" }) -- Command + /
keymap({ "n", "v" }, "<C-/>", toggle_cmt, { expr = true, desc = "Toggle comment line" }) -- Control + /
keymap("i", "<C-/>", i_mode_toggle_cmt, { desc = "Toggle comment line" }) -- Control + /
