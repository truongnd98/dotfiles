return {
	"nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  -- event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
      hide_root_node = true,
      use_default_mappings = false,
      buffers = {
        bind_to_cwd = false,
      },
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						"node_modules",
						".git",
            "dist",
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
        bind_to_cwd = false,
				use_libuv_file_watcher = true,
				window = {
					mappings = {
            ["<cr>"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["z"] = "close_all_nodes",
            ["R"] = "refresh",
            ["a"] = {
              "add",
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none", -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["e"] = "toggle_auto_expand_width",
            ["q"] = "close_window",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["H"] = "toggle_hidden",
					},
				},
			},
      enable_diagnostics = false,
      -- enable_git_status = false,
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
