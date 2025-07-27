-- -- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
-- vim.g.autoformat = false

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = "zsh"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

vim.opt.clipboard = "unnamedplus"

vim.opt.cursorline = true
-- vim.opt.colorcolumn = "94"

vim.opt.grepprg = "rg --vimgrep -n"
-- vim.opt.grepformat = "%f:%l:%c:%m"

vim.opt.termguicolors = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Enable spell check
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

vim.opt.updatetime = 300

-- vim.g.terminal_color_0 = "#444b6a"
-- vim.g.terminal_color_1 = "#ff7a93"
-- vim.g.terminal_color_2 = "#19ac19"
-- vim.g.terminal_color_3 = "#ff9e64"
-- vim.g.terminal_color_4 = "#7da6ff"
-- vim.g.terminal_color_5 = "#bb9af7"
-- vim.g.terminal_color_6 = "#0db9d7"
-- vim.g.terminal_color_7 = "#acb0d0"
--
-- vim.g.terminal_color_8 = "#32344a"
-- vim.g.terminal_color_9 = "#ff453a"
-- vim.g.terminal_color_10 = "#32d74b"
-- vim.g.terminal_color_11 = "#ff9f0a"
-- vim.g.terminal_color_12 = "#0a84ff"
-- vim.g.terminal_color_13 = "#ad8ee6"
-- vim.g.terminal_color_14 = "#5ac8f5"
-- vim.g.terminal_color_15 = "#787c99"

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

local g = vim.g

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0
