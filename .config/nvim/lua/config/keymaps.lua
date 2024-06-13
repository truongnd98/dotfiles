-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
local keymap = Util.safe_keymap_set

local make_opts = function(custom_opts)
  return vim.tbl_extend("force", { silent = true }, custom_opts or {})
end

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
