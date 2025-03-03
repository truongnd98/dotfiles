return {
	"nvim-neo-tree/neo-tree.nvim",
  -- enabled = false,
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
						-- untracked = "󱈸  ",
						-- ignored = "",
						-- unstaged = "󰄱  ",
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "󰸞  ",
						conflict = "  ",
					},
				},
			},
		})

		local keymap = vim.keymap
		local opts = { noremap = true, silent = true }

		keymap.set("n", "<leader>e", function()
			require("neo-tree.command").execute({ toggle = false })
		end, opts)
		keymap.set("n", "<leader>q", function()
			require("neo-tree.command").execute({ toggle = true })
		end, opts)

		keymap.set("n", "<leader>E", function()
			require("neo-tree.command").execute({ toggle = false })
		end, opts)
		keymap.set("n", "<leader>Q", function()
			require("neo-tree.command").execute({ toggle = true })
		end, opts)
	end,
}
