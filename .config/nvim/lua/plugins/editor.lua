return {
	{
		"telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")

			local opts = {
				defaults = {
					wrap_results = true,
					layout_strategy = "horizontal",
					-- layout_config = { prompt_position = "top" },
					path_display = { truncate = 3 },
					-- sorting_strategy = "ascending",
					winblend = 0,
					mappings = {
						n = {},
					},
				},
				pickers = {
					diagnostics = {
						theme = "ivy",
						initial_mode = "normal",
						layout_config = {
							preview_cutoff = 999,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			}

			telescope.setup(opts)
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			-- set keymaps
      local keymap = vim.keymap -- for conciseness

			keymap.set(
				"n",
				"<leader>ff",
				"<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find files in cwd" }
			)
			keymap.set(
				"n",
				"<leader>fs",
				"<cmd>Telescope live_grep hidden=true no_ignore=true<cr>",
				{ desc = "Find string in cwd" }
			)

			-- disable keymap <leader><leader>
			keymap.set("n", "<leader><leader>", "<nop>", { desc = "Disable <leader><leader>", nowait = true })
		end,
	},

}
