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
  vim.keymap.set("n", "rn",             api.fs.rename,                      opts("Rename"))
  vim.keymap.set("n", "R",              api.tree.reload,                    opts("Refresh"))
  vim.keymap.set("n", "W",              api.tree.collapse_all,              opts("Collapse All"))
  vim.keymap.set("n", "x",              api.fs.cut,                         opts("Cut"))
  vim.keymap.set("n", "y",              api.fs.copy.filename,               opts("Copy Name"))
  vim.keymap.set("n", "Y",              api.fs.copy.relative_path,          opts("Copy Relative Path"))
end

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeOpen<CR>", desc = "NvimTree Open" },
    { "<leader>E", "<cmd>NvimTreeOpen<CR>", desc = "NvimTree Open" },
    { "<leader>q", "<cmd>NvimTreeClose<CR>", desc = "NvimTree Close" },
    { "<leader>Q", "<cmd>NvimTreeClose<CR>", desc = "NvimTree Close" },
  },
  opts = {
    root_dirs = {},
    hijack_netrw = true,
    hijack_cursor = false,
    sync_root_with_cwd = false,
    respect_buf_cwd = false,
    filters = {
      dotfiles = false,
      custom = {
        "^%.DS_Store$",
        "^thumbs%.db$",
      },
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
    actions = {
      open_file = {
        resize_window = true,
      },
    },
    view = {
      signcolumn = "yes",
      width = 45,
    },
    renderer = {
      root_folder_label = false,
      icons = {
        git_placement = "signcolumn",
        glyphs = {
          bookmark = "",
          modified = "",
          git = {
            unstaged = "~", staged = "✓", unmerged = "",
            renamed = "➜", untracked = "#", deleted = "✗", ignored = "◌",
          }
        }
      }
    },
    filesystem_watchers = { enable = false },
    update_focused_file = { enable = false },
    on_attach = on_attach,
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
