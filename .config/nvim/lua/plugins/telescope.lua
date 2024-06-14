return {
  "nvim-telescope/telescope.nvim",
  -- enabled = false,
  -- branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "truongnd98/project-manager.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_source_telescope = require("trouble.sources.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        path_display = {
          -- "smart"
        },
        set_env = {
          COLORTERM = "xterm-256color",
          LESS = "",
          DELTA_PAGER = "less",
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_source_telescope.open,
          },
        },
      },
    })

    print("CWD: " .. vim.loop.cwd())

    telescope.load_extension("fzf")
    telescope.load_extension("project-manager")
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep hidden=true<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

    keymap.set(
      "n",
      "<leader>fd",
      "<cmd>Telescope find_files cwd=~/Desktop/<cr> hidden=true",
      { desc = "Fuzzy find files in Desktop" }
    )
    keymap.set(
      "n",
      "<leader>fdd",
      "<cmd>Telescope live_grep <cwd=~/Desktop/cr> hidden=true",
      { desc = "Find string in Desktop" }
    )

    keymap.set(
      "n",
      "<leader>d",
      "<cmd>Telescope project-manager find_dirs hidden=true<cr>",
      { desc = "Fuzzy find folder in cwd" }
    )
    keymap.set(
      "n",
      "<leader>dd",
      "<cmd>Telescope project-manager live_find_dirs hidden=true<cr>",
      { desc = "Fuzzy live find folder in cwd" }
    )

    keymap.set(
      "n",
      "<leader>df",
      "<cmd>Telescope project-manager find_dirs cwd=~/Desktop/ hidden=true<cr>",
      { desc = "Fuzzy find folder in Desktop" }
    )
    keymap.set(
      "n",
      "<leader>dff",
      "<cmd>Telescope project-manager live_find_dirs cwd=~/Desktop/ hidden=true<cr>",
      { desc = "Fuzzy live find folder in Desktop" }
    )
    -- disable keymap <leader><leader>
    keymap.set("n", "<leader><leader>", "<nop>", { desc = "Disable <leader><leader>", nowait = true })
  end,
}
