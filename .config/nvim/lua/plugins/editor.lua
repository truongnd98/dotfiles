return {
	-- {
	-- 	enabled = false,
	-- 	"folke/flash.nvim",
	-- 	---@type Flash.Config
	-- 	opts = {
	-- 		search = {
	-- 			forward = true,
	-- 			multi_window = false,
	-- 			wrap = false,
	-- 			incremental = true,
	-- 		},
	-- 	},
	-- },

	-- {
	-- 	"echasnovski/mini.hipatterns",
	-- 	event = "BufReadPre",
	-- 	opts = {
	-- 		highlighters = {
	-- 			hsl_color = {
	-- 				pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
	-- 				group = function(_, match)
	-- 					local utils = require("solarized-osaka.hsl")
	-- 					--- @type string, string, string
	-- 					local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
	-- 					--- @type number?, number?, number?
	-- 					local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
	-- 					--- @type string
	-- 					local hex_color = utils.hslToHex(h, s, l)
	-- 					return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
	-- 				end,
	-- 			},
	-- 		},
	-- 	},
	-- },

	-- {
	-- 	"dinhhuy258/git.nvim",
	-- 	event = "BufReadPre",
	-- 	opts = {
	-- 		keymaps = {
	-- 			-- Open blame window
	-- 			blame = "<Leader>gb",
	-- 			-- Open file/folder in git repository
	-- 			browse = "<Leader>go",
	-- 		},
	-- 	},
	-- },

	{
		"telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"truongnd98/project-manager.nvim",
		},
		config = function()
			local telescope = require("telescope")

			local opts = {
				defaults = {
					wrap_results = true,
					layout_strategy = "horizontal",
					layout_config = { prompt_position = "top" },
					path_display = { truncate = 3 },
					sorting_strategy = "ascending",
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
							preview_cutoff = 9999,
						},
					},
				},
			}

			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("project-manager")

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set(
				"n",
				"<leader>ff",
				"<cmd>Telescope project-manager find_files hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find files in cwd" }
			)
			keymap.set(
				"n",
				"<leader>fs",
				"<cmd>Telescope project-manager live_grep hidden=true no_ignore=true<cr>",
				{ desc = "Find string in cwd" }
			)
			keymap.set(
				"n",
				"<leader>fc",
				"<cmd>Telescope project-manager grep_string hidden=true no_ignore=true<cr>",
				{ desc = "Find string under cursor in cwd" }
			)
			keymap.set(
				"n",
				"<leader>fd",
				"<cmd>Telescope project-manager find_files cwd=~/Desktop/ hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find files in Desktop" }
			)

			keymap.set(
				"n",
				"<leader>d",
				"<cmd>Telescope project-manager find_dirs hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find folder in cwd" }
			)
			keymap.set(
				"n",
				"<leader>dd",
				"<cmd>Telescope project-manager live_find_dirs hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy live find folder in cwd" }
			)
			keymap.set(
				"n",
				"<leader>ds",
				"<cmd>Telescope project-manager find_dirs cwd=~/Desktop/ hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy find folder in Desktop" }
			)
			keymap.set(
				"n",
				"<leader>df",
				"<cmd>Telescope project-manager live_find_dirs cwd=~/Desktop/ hidden=true no_ignore=true<cr>",
				{ desc = "Fuzzy live find folder in Desktop" }
			)

			keymap.set(
				"n",
				"<leader>p",
				"<cmd>Telescope project-manager find_projects cwd=~/Desktop/<cr>",
				{ desc = "Find projects" }
			)

			-- disable keymap <leader><leader>
			keymap.set("n", "<leader><leader>", "<nop>", { desc = "Disable <leader><leader>", nowait = true })
		end,
	},
}
