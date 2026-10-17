return {
  {
    -- Ghi đủ `owner/repo`: dạng ngắn "telescope.nvim" chỉ resolve được vì
    -- project-manager.lua khai đủ tên trong dependencies - tức thứ tự đọc file
    -- trở thành dependency ngầm.
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    -- `defaults.lazy = false` (config/lazy.lua) nên không có `cmd`/`keys` là
    -- telescope + 2 extension load ngay lúc khởi động. Khai keymap ở `keys`
    -- thay vì trong `config` để lazy.nvim dựng map trước, chỉ nạp plugin khi
    -- thực sự bấm.
    cmd = "Telescope",
    keys = {
      -- `--hidden` để thấy .github/, .env.example...; `--exclude .git` để không
      -- lội vào object của git. KHÔNG dùng `--no-ignore`: với repo Go/Rust nó
      -- kéo cả `target/`, `vendor/`, `node_modules/` vào kết quả.
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            find_command = {
              "fd", "--type", "f", "--color", "never", "--follow", "--hidden", "--exclude", ".git",
            },
          })
        end,
        desc = "Fuzzy find files in cwd",
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").live_grep({ hidden = true })
        end,
        desc = "Find string in cwd",
      },
      -- Khi thật sự cần tìm trong file bị .gitignore (build output, vendor).
      {
        "<leader>fa",
        function()
          require("telescope.builtin").find_files({
            find_command = {
              "fd", "--type", "f", "--color", "never", "--follow", "--hidden", "--no-ignore",
              "--exclude", ".git",
            },
          })
        end,
        desc = "Fuzzy find files in cwd (kể cả file bị ignore)",
      },
      -- Buffer picker: với >10 buffer đang mở thì nhanh hơn <C-j>/<C-k> tuần
      -- tự rất nhiều. `<C-d>` (insert) / `dd` (normal) để đóng buffer tại chỗ.
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find buffers",
      },
      -- File đã mở gần đây, kể cả ở project khác.
      {
        "<leader>fo",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find recently opened files",
      },
      -- Mở lại picker vừa rồi, giữ nguyên query + vị trí con trỏ. Rất đáng có
      -- khi đang lần theo một chuỗi kết quả grep trong codebase lớn.
      {
        "<leader>fr",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume last picker",
      },
      -- Grep thẳng từ dưới con trỏ (normal) hoặc vùng đang chọn (visual).
      {
        "<leader>fg",
        function()
          require("telescope.builtin").grep_string()
        end,
        mode = { "n", "v" },
        desc = "Grep word under cursor / selection",
      },
    },
    config = function()
      local telescope = require("telescope")

      local opts = {
        defaults = {
          -- `path_display = truncate` đã lo đường dẫn dài, không cần wrap.
          wrap_results = false,
          layout_strategy = "horizontal",
          borderchars = { "━", "┃", "━", "┃","┏", "┓", "┛", "┗" },
          -- Override `vimgrep_arguments` làm mất default của telescope:
          --   { "rg", "--color=never", "--no-heading", "--with-filename",
          --     "--line-number", "--column", "--smart-case" }
          -- `--vimgrep` đã gộp no-heading/with-filename/line-number/column,
          -- nhưng `--smart-case` và `--color=never` thì không. Phải ghi lại:
          --   - `--smart-case`: trước đây vẫn chạy nhờ ~/.ripgreprc, tức là
          --     phụ thuộc ngầm vào một file ngoài repo nvim.
          --   - `--color=never`: docs telescope yêu cầu tường minh vì nó chưa
          --     interpret ANSI color code.
          vimgrep_arguments = {
            "rg", "--vimgrep", "--smart-case", "--color=never", "--glob", "!.git/*",
          },
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
          buffers = {
            sort_mru = true,          -- buffer vừa dùng lên đầu
            sort_lastused = true,
            ignore_current_buffer = true,
            mappings = {
              i = { ["<C-d>"] = "delete_buffer" },
              n = { ["dd"] = "delete_buffer" },
            },
          },
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

      -- Keymap đã chuyển lên `keys` ở trên.
    end,
  },
}
