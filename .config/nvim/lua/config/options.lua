-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

vim.cmd("let g:netrw_liststyle = 3")

-- -- UFO folding
-- opt.foldcolumn = "1" -- '0' is not bad
-- opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- opt.foldlevelstart = 99
-- opt.foldenable = true
-- opt.fillchars = {
--   eob = " ",
--   fold = " ",
--   foldopen = "",
--   foldsep = " ",
--   foldclose = "",
-- }

-- CUSTOM OPT
opt.showmode = true
opt.mouse = ""
-- opt.mouse = "a"
opt.timeoutlen = 250
opt.updatetime = 40
opt.ttimeoutlen = 50
opt.guicursor = "sm:block,n-v-i-c-ci-ve:ver30,r-cr-o:hor20"
opt.virtualedit = { "block", "onemore" }
-- opt.listchars:append({ tab = "▷▷⋮" })
-- opt.listchars:append({ space = "_" })
opt.listchars:append({ eol = "↲" })

opt.relativenumber = true
opt.number = true

-- -- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- opt.guifont = "JetBrainsMono Nerd Font Mono:h14"

---- FOR NEOVIM-DEOVIDE ----

local g = vim.g
-- Helper function for transparency formatting
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end
-- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
-- g.neovide_transparency = 0.0
-- g.transparency = 0.3
-- g.neovide_background_color = "#1F2335" .. alpha()

g.neovide_show_border = true
g.neovide_window_blurred = true
g.neovide_underline_stroke_scale = 1.0
