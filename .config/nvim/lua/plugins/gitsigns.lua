return {
  "lewis6991/gitsigns.nvim",
  -- enabled = false,
  event = "VeryLazy",
  config = function()
    require("gitsigns").setup(
      {
        signs = {
          add = { text = "▎" },
          -- change = { text = "∼" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "~" },
        },
        signs_staged = {
          add = { text = "▎" },
          -- change = { text = "∼" },
          change = { text = "▎" },
          delete = { text = "▁" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "~" },
        },
        signs_staged_enable = true,
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        -- numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        -- linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        -- word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 500,
          virt_text_pos = "eol",
          virt_text_priority = 1000,
        },
        current_line_blame_formatter =   " <abbrev_sha>: <author>, <author_time:%R> - <summary> ",
        on_attach = function (bufnr)
          local function opts(desc)
            return { desc = "gitsigns: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Set up keymaps
          local keymap = vim.keymap -- for conciseness

          keymap.set("n", "<leader>b", ":Gitsigns blame_line<CR>", opts("Toggle blame line"))
        end
      }
    )
  end,
}
