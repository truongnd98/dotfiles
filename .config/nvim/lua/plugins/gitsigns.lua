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
        -- Tắt mặc định: blame theo dòng spawn `git blame` mỗi lần cursor dừng,
        -- trên repo lớn đây là nguồn lag rõ rệt. Bật khi cần bằng <leader>gB.
        current_line_blame = false,
        current_line_blame_opts = {
          delay = 500,
          virt_text_pos = "eol",
          virt_text_priority = 1000,
        },
        current_line_blame_formatter =   " <abbrev_sha>: <author>, <author_time:%R> - <summary> ",
        on_attach = function(bufnr)
          local gs = require("gitsigns")

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              desc = "gitsigns: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            })
          end

          -- Hunk navigation: `]h` / `[h` (convention kiểu vim-unimpaired).
          -- Không dùng `]c`/`[c` vì treesitter-textobjects đã chiếm cho @class.
          -- Trong diff mode thì nhường lại `]c`/`[c` gốc của vim.
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, "Next hunk")
          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, "Prev hunk")

          -- Stage / reset theo hunk - đây mới là phần giá trị chính của
          -- gitsigns. Bản visual stage/reset đúng vùng đang chọn (partial hunk).
          map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
          map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
          map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Stage selected lines")
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, "Reset selected lines")
          map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
          -- `stage_hunk` trên hunk đã staged = unstage, nên nó cũng là undo.
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

          map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>gd", gs.diffthis, "Diff against index")
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, "Diff against last commit")

          -- Blame: `<leader>gb` popup đầy đủ (commit message + diff),
          -- `<leader>gB` bật/tắt virtual text theo dòng.
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, "Blame line (full)")
          map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle inline blame")

          -- Giữ binding cũ `<leader>b` để không phải đổi phản xạ.
          map("n", "<leader>b", function()
            gs.blame_line({ full = true })
          end, "Blame line (full)")

          -- Text object: `ih` = inner hunk, dùng được với d/c/y.
          map({ "o", "x" }, "ih", gs.select_hunk, "Select hunk")
        end
      }
    )
  end,
}
