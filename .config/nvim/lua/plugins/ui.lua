return {
	-- animations
	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function(_, opts)
			opts.scroll = {
				enable = false,
			}
			opts.resize = {
				enable = false,
			}
			opts.open = {
				enable = false,
			}
			opts.close = {
				enable = false,
			}
		end,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = {
			-- plugins = {
			-- 	gitsigns = true,
			-- 	tmux = true,
			-- 	kitty = { enabled = false, font = "+2" },
			-- },
		},
		keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	},
}
