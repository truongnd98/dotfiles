-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Tôn trọng `.editorconfig` của repo: làm việc trên code của team mà tắt cái
-- này thì indent gõ tay sẽ lệch với convention của project.
vim.g.editorconfig = true

vim.g.mapleader = " "
vim.g.autoformat = false

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.lazyredraw = false       -- Don’t redraw while executing macros
vim.opt.synmaxcol = 200         -- Limit syntax highlight columns
vim.opt.updatetime = 300        -- Reduce CursorHold delay
vim.opt.redrawtime = 1500        -- Max time for syntax highlight

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 🌟 FIX LỖI SYMLINK: Bắt buộc Neovim dùng cơ chế copy khi ghi đè qua liên kết đường dẫn
vim.opt.backupcopy = "yes"

vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = "zsh"
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" }
vim.opt.inccommand = "split"
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.list = true
vim.opt.listchars:append({ space = "·", trail = "·" })

vim.opt.clipboard = "unnamedplus"

-- Tối ưu hóa Code Folding bằng Treesitter cho Neovim mới
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- 🌟 Sử dụng hàm native mới mượt hơn của Nvim
-- foldtext rỗng: dòng bị fold vẫn giữ syntax highlight thay vì thành một dòng
-- `+--  12 lines:` đơn sắc.
vim.opt.foldtext = ""
vim.opt.foldlevel = 99

vim.opt.termguicolors = true

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Enable spell check
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- Allow Neovim to read local .vimrc and .exrc files in the current directory
vim.opt.exrc = true

local g = vim.g

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

g.lazyvim_blink_main = false

local disabled_built_ins = {
  "gzip", "zip", "zipPlugin", "tar", "tarPlugin", "getscript",
  "getscriptPlugin", "vimball", "vimballPlugin", "matchit",
  "matchparen", "netrw", "netrwPlugin", "rplugin",
  "synmenu", "optwin", "compiler", "bugreport", "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
  },
  signs = true,         -- Show signs in the gutter (sign column)
  underline = true,     -- Underline problematic text
  update_in_insert = false, -- Don't update while typing in insert mode
  severity_sort = true,   -- Sort by severity (Error > Warning > Info > Hint)
})

-- Tăng tốc độ tối đa bằng cách giảm thiểu ghi đĩa (I/O)
vim.opt.swapfile = false       -- noswapfile: Không tạo file .swp
vim.opt.writebackup = false    -- nowritebackup: Không tạo backup tạm thời khi đang ghi
vim.opt.backup = false         -- nobackup: Không giữ lại file backup sau khi lưu

-- undofile là ngoại lệ: đây là file duy nhất đáng ghi ra đĩa. Ghi một lần khi
-- lưu (vài KB) nhưng giữ được undo sau khi đóng file - đổi lại rất nhiều.
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- 🌟 LƯU Ý CHO NVIM v0.12+: KHÔNG tắt hoàn toàn shada bằng chuỗi rỗng ("") 
-- vì nó sẽ làm mất các tính năng cốt lõi của LazyVim (như lưu trạng thái UI, lịch sử lệnh cũ).
-- Thay vào đó, cấu hình nhẹ để tăng tốc:
vim.opt.shada = "!,'10,<50,s10,h"

-- Tự động thêm dòng trống ở cuối file khi lưu
vim.opt.fixeol = true
-- Đảm bảo file luôn kết thúc bằng một ký tự xuống dòng (newline)
vim.opt.eol = true
