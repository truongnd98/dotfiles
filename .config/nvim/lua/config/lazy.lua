local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- `vim.uv`, không phải `vim.loop`: loop là alias deprecated từ 0.10. Các file
-- khác trong config (treesitter.lua, neotest.lua) đã dùng vim.uv.
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	-- Colorscheme lazy.nvim dùng cho UI lúc cài plugin. Trước đây là "gruvbox"
	-- - theme đó không được cài, nên lazy fallback về habamax.
	install = { colorscheme = { "aurora" } },
	defaults = {
		lazy = false,
		version = false,
	},
	checker = { enabled = false, notify = false },
	change_detection = { notify = false },
	performance = {
		cache = {
			enabled = true,
			disable_events = {},
		},
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				-- "gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				-- "rplugin",
				-- "tarPlugin",
				-- "tohtml",
				-- "tutor",
				-- "zipPlugin",
			},
		},
	},
	ui = {
		custom_keys = {
			["<leader>d"] = function(plugin)
				dd(plugin)
			end,
		},
		icons = {
			cmd = "⌘",
			config = "🛠", -- 🌟
			event = "📅",
			ft = "📂",
			init = "🔆",
			keys = "🗝",
			plugin = "🔌", -- 🧩
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	debug = false,
  -- Để `false` cho dùng hằng ngày: `require = true` bọc mọi lệnh require để
  -- đo thời gian, tức là trả overhead đó ở mọi lần khởi động. Bật tạm khi cần
  -- chạy `:Lazy profile`.
  profiling = {
    loader = false,
    require = false,
  },
})
