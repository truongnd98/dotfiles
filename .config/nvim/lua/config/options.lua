-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.autoformat = false

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.lazyredraw = true       -- Don’t redraw while executing macros
vim.opt.synmaxcol = 200         -- Limit syntax highlight columns
vim.opt.updatetime = 300        -- Reduce CursorHold delay
vim.opt.redrawtime = 500        -- Max time for syntax highlight

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

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
-- vim.opt.path:append({ "**" }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.clipboard = "unnamedplus"

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

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

local g = vim.g

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

g.lazyvim_blink_main = false

local disabled_built_ins = {
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin", "getscript", 
  "getscriptPlugin", "vimball", "vimballPlugin", "matchit", 
  "matchparen", "netrw", "netrwPlugin", "rplugin", "syntax", 
  "synmenu", "optwin", "compiler", "bugreport", "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
