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
          borderchars = { "━", "┃", "━", "┃","┏", "┓", "┛", "┗" },
          vimgrep_arguments = { "rg", "--vimgrep" },
          -- layout_config = { prompt_position = "top" },
          path_display = { truncate = 3 },
          -- sorting_strategy = "ascending",
          winblend = 0,
          wrap_results = false,
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
        function ()
          require("telescope.builtin").find_files({
            find_command = { "fd", "--type", "f", "--color", "never", "--follow", "--hidden", "--no-ignore" },
          })
        end,
        { desc = "Fuzzy find files in cwd" }
      )
      keymap.set(
        "n",
        "<leader>fs",
        function ()
          require("telescope.builtin").live_grep({ hidden = true, no_ignore = true })
        end,
        { desc = "Find string in cwd" }
      )

      -- disable keymap <leader><leader>
      keymap.set("n", "<leader><leader>", "<nop>", { desc = "Disable <leader><leader>", nowait = true })
    end,
  },
}
