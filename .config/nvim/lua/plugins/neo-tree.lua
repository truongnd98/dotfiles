return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						"node_modules",
						".git",
					},
					never_show = {
						".DS_Store",
						"thumbs.db",
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				-- use_libuv_file_watcher = true,
				window = {
					mappings = {
						["s"] = "",
					},
				},
			},
			default_component_configs = {
				diagnostics = {
					symbols = {
						error = "  ",
						warn = "  ",
						info = "  ",
						hint = "  ",
					},
				},
				git_status = {
					symbols = {
						-- Change type
						added = "✚  ",
						deleted = "󱎘  ",
						modified = "∼  ",
						renamed = "󰁕  ",
						-- Status type
						untracked = "󱈸  ",
						ignored = "",
						unstaged = "󰄱  ",
						staged = "󰸞  ",
						conflict = "  ",
					},
				},
			},
		})

		local keymap = vim.keymap
		local opts = { noremap = true, silent = true }

		keymap.set("n", "<leader>e", function()
			vim.schedule(function()
				require("neo-tree.command").execute({ toggle = false })
			end)
		end, opts)
		keymap.set("n", "<leader>ee", function()
			vim.schedule(function()
				require("neo-tree.command").execute({ toggle = true })
			end)
		end, opts)

		keymap.set("n", "<leader>E", function()
			vim.schedule(function()
				require("neo-tree.command").execute({ toggle = false })
			end)
		end, opts)
		keymap.set("n", "<leader>EE", function()
			vim.schedule(function()
				require("neo-tree.command").execute({ toggle = true })
			end)
		end, opts)
	end,
}
