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
          -- `path_display = truncate` đã lo đường dẫn dài, không cần wrap.
          wrap_results = false,
          layout_strategy = "horizontal",
          borderchars = { "━", "┃", "━", "┃","┏", "┓", "┛", "┗" },
          -- `!.git` cần thiết vì <leader>fs truyền `--hidden` cho rg.
          vimgrep_arguments = { "rg", "--vimgrep", "--glob", "!.git/*" },
          -- layout_config = { prompt_position = "top" },
          path_display = { truncate = 3 },
          -- sorting_strategy = "ascending",
          winblend = 0,
          mappings = {
            n = {},
          },
          preview = {
            treesitter = false,
            filesize_limit = 1,
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

      -- `--hidden` để thấy .github/, .env.example...; `--exclude .git` để không
      -- lội vào object của git. KHÔNG dùng `--no-ignore`: với repo Go/Rust nó
      -- kéo cả `target/`, `vendor/`, `node_modules/` vào kết quả.
      keymap.set(
        "n",
        "<leader>ff",
        function ()
          require("telescope.builtin").find_files({
            find_command = {
              "fd", "--type", "f", "--color", "never", "--follow", "--hidden", "--exclude", ".git",
            },
          })
        end,
        { desc = "Fuzzy find files in cwd" }
      )
      keymap.set(
        "n",
        "<leader>fs",
        function ()
          require("telescope.builtin").live_grep({ hidden = true })
        end,
        { desc = "Find string in cwd" }
      )
      -- Khi thật sự cần tìm trong file bị .gitignore (build output, vendor).
      keymap.set(
        "n",
        "<leader>fa",
        function ()
          require("telescope.builtin").find_files({
            find_command = {
              "fd", "--type", "f", "--color", "never", "--follow", "--hidden", "--no-ignore",
              "--exclude", ".git",
            },
          })
        end,
        { desc = "Fuzzy find files in cwd (kể cả file bị ignore)" }
      )

      -- disable keymap <leader><leader>
      keymap.set("n", "<leader><leader>", "<nop>", { desc = "Disable <leader><leader>", nowait = true })
    end,
  },
}
