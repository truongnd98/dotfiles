local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
	install = { colorscheme = { "gruvbox" } },
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
  profiling = {
    loader = false,
    require = true,
  },
})
