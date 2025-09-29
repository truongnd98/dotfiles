local function on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set("n", "<CR>",           api.node.open.edit,                 opts("Open"))
  vim.keymap.set("n", "<Tab>",          api.node.open.preview,              opts("Open Preview"))
  vim.keymap.set("n", "a",              api.fs.create,                      opts("Create File Or Directory"))
  vim.keymap.set("n", "c",              api.fs.copy.node,                   opts("Copy"))
  vim.keymap.set("n", "dd",             api.fs.trash,                       opts("Trash"))
  vim.keymap.set("n", "DD",             api.fs.trash,                       opts("Trash"))
  vim.keymap.set("n", "E",              api.tree.expand_all,                opts("Expand All"))
  vim.keymap.set("n", "H",              api.tree.toggle_hidden_filter,      opts("Toggle Filter: Dotfiles"))
  vim.keymap.set("n", "I",              api.tree.toggle_gitignore_filter,   opts("Toggle Filter: Git Ignore"))
  vim.keymap.set("n", "o",              api.node.open.edit,                 opts("Open"))
  vim.keymap.set("n", "O",              api.node.open.no_window_picker,     opts("Open: No Window Picker"))
  vim.keymap.set("n", "p",              api.fs.paste,                       opts("Paste"))
  vim.keymap.set("n", "q",              api.tree.close,                     opts("Close"))
  vim.keymap.set("n", "r",              api.fs.rename,                      opts("Rename"))
  vim.keymap.set("n", "R",              api.tree.reload,                    opts("Refresh"))
  vim.keymap.set("n", "W",              api.tree.collapse_all,              opts("Collapse All"))
  vim.keymap.set("n", "x",              api.fs.cut,                         opts("Cut"))
  vim.keymap.set("n", "y",              api.fs.copy.filename,               opts("Copy Name"))
  vim.keymap.set("n", "Y",              api.fs.copy.relative_path,          opts("Copy Relative Path"))
end

return {
  "nvim-tree/nvim-tree.lua",
	dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function ()
    require("nvim-tree").setup({
      view = {
        signcolumn = "auto",
      },
      diagnostics = {
        enable = true,
        debounce_delay = 300,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      modified = {
        enable = true,
      },
      renderer = {
        root_folder_label = false,
        indent_width = 3,
        icons = {
          show = {
            bookmarks = false,
          },
          -- git_placement = "after",
          -- bookmarks_placement = "after",
          diagnostics_placement = "after",
          -- symlink_arrow = " -> ",
          glyphs = {
            folder = {
              -- arrow_closed = " ",
              -- arrow_open = " ",
              -- default = "",
              -- open = "",
              -- empty = "",
              -- empty_open = "",
              -- symlink = "",
              -- symlink_open = ""
            },
            -- default = "󱓻",
            -- symlink = "󱓻",
            -- bookmark = "",
            modified = "",
            hidden = "󱙝",
            git = {
              unstaged = "×",
              staged = "",
              unmerged = "󰧾",
              untracked = "",
              renamed = "",
              deleted = "",
              ignored = "∅",
            }
          }
        }
      },
      filters = {
        custom = {
          "^node_modules$",
          "^.git$",
          "^dist$",
          "^%.DS_Store$",
          "^thumbs%.db$",
        },
      },
      hijack_cursor = true,
      sync_root_with_cwd = true,
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      on_attach = on_attach,
    })

		local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>e", ":NvimTreeOpen<CR>", opts)
    vim.keymap.set("n", "<leader>E", ":NvimTreeOpen<CR>", opts)
    vim.keymap.set("n", "<leader>q", ":NvimTreeClose<CR>", opts)
    vim.keymap.set("n", "<leader>Q", ":NvimTreeClose<CR>", opts)
  end,
}
