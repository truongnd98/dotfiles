-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Tôn trọng `.editorconfig` của repo: làm việc trên code của team mà tắt cái
-- này thì indent gõ tay sẽ lệch với convention của project.
vim.g.editorconfig = true

vim.g.mapleader = " "
-- `vim.g.autoformat = false` đã xoá: đó là biến của LazyVim, config này không
-- dùng LazyVim. Format-on-save ở đây do config/autocmds.lua lo, tắt bằng
-- `:FormatToggle`.

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

-- Symlink: giữ inode khi ghi (dotfiles ở đây được symlink vào $HOME).
-- Lưu ý `backup`/`writebackup` đều đã tắt ở dưới, mà khi không có backup thì
-- Nvim ghi đè in-place nên symlink vốn đã an toàn - dòng này chỉ là lưới an
-- toàn nếu sau này bật lại writebackup.
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

-- Spell check: `spelllang` để global, nhưng KHÔNG bật `spell` ở đây.
-- Hai lý do: (1) nó tốn ~17ms startup vì phải nạp spell file, bằng ~18% tổng
-- thời gian khởi động; (2) bật cho code là sai - `fn`, `buf`, `str`, `nvim`,
-- `impl` đều bị gạch đỏ. Bật theo filetype ở config/autocmds.lua.
vim.opt.spelllang = { "en_us" }

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- `exrc` TẮT. Nvim có gate bằng vim.secure (hỏi trust trước khi chạy) nên
-- không phải lỗ hổng thẳng, nhưng nghĩa là: clone một repo lạ, mở nvim, và chỉ
-- còn cách một lần bấm "y" bất cẩn là chạy Lua tuỳ ý của người khác với full
-- quyền của mình. Trust DB (~/.local/share/nvim/trust) đang trống và không có
-- file .nvim.lua nào trong các project -> tính năng này chưa từng được dùng,
-- nên không mất gì.
-- Cần per-project config thì bật lại có chủ đích: `:set exrc` rồi `:e .nvim.lua`.
vim.opt.exrc = false

local g = vim.g

g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Tắt runtime plugin không dùng. Danh sách này phải khớp với
-- $VIMRUNTIME/plugin/ của Nvim 0.12, nếu không thì chỉ là set biến vô nghĩa.
-- Đã bỏ khỏi danh sách cũ vì KHÔNG tồn tại trong Nvim (chúng là runtime file
-- của Vim): zip, tar, getscript, getscriptPlugin, vimball, vimballPlugin,
-- synmenu, optwin, compiler, bugreport, ftplugin.
-- Và `rplugin` sai tên biến: rplugin.vim kiểm tra `g:loaded_remote_plugins`,
-- nên remote plugin trước giờ vẫn được load.
-- Giữ lại `man`, `spellfile`, `osc52`, `editorconfig`, `shada`: đều hữu ích.
local disabled_built_ins = {
  "gzip",
  "zipPlugin",
  "tarPlugin",
  "matchit",
  "matchparen",        -- blink.pairs lo matchparen (xem plugins/blink-pairs.lua)
  "netrwPlugin",       -- nvim-tree thay thế
  "remote_plugins",    -- provider python/ruby/perl/node đều đã tắt ở trên
  "tutor_mode_plugin",
}

for _, plugin in ipairs(disabled_built_ins) do
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

-- KHÔNG tắt hoàn toàn shada bằng chuỗi rỗng (""): mất luôn marks, jumplist
-- giữa các session, lịch sử lệnh và register. Cấu hình nhẹ thay vì tắt:
--   !     lưu biến global VIẾT HOA
--   '10   10 file trong oldfiles (telescope <leader>fo đọc cái này)
--   <50   tối đa 50 dòng mỗi register
--   s10   bỏ qua item > 10KB
--   h     không lưu hlsearch
vim.opt.shada = "!,'10,<50,s10,h"

-- Tự động thêm dòng trống ở cuối file khi lưu
vim.opt.fixeol = true
-- Đảm bảo file luôn kết thúc bằng một ký tự xuống dòng (newline)
vim.opt.eol = true
