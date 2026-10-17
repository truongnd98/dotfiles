return {
  "saghen/blink.cmp",
  dependencies = {
    -- -- optional: provides snippets for the snippet source
    -- 'rafamadriz/friendly-snippets',
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      -- jsregexp để snippet dùng transform (vd: `${1/.*/\U$0/}`) chạy được.
      build = "make install_jsregexp",
      opts = { history = true, delete_check_events = "TextChanged" },
    },
  },

  -- Tự có trigger riêng: lspconfig require blink lúc BufReadPre, nhưng nếu mở
  -- `nvim` không file rồi gõ vào buffer trống thì không có BufReadPre nào -
  -- `InsertEnter`/`CmdlineEnter` đảm bảo vẫn có completion.
  event = { "InsertEnter", "CmdlineEnter" },

  -- `version = '*'` -> lazy checkout release tag, blink tự tải binary fuzzy
  -- matcher dựng sẵn. KHÔNG thêm `build = require('blink.cmp').build()`:
  -- cái đó chạy `cargo build --release` (cần Rust nightly) cho một thứ đã có.
  version = "*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = {
      preset = "luasnip",
      -- search_paths = { vim.g.vscode_snippets_path },
    },
    keymap = {
      -- `snippet_forward` phải đứng TRƯỚC `select_next`: không có nó thì không
      -- có phím nào nhảy giữa các placeholder của snippet - mà config này bật
      -- `usePlaceholders` (gopls), `callSnippet = "Replace"` (lua_ls) và
      -- `auto_brackets`, tức là liên tục sinh ra snippet có placeholder.
      -- Thứ tự: đang trong snippet -> nhảy; menu đang mở -> chọn dòng kế;
      -- còn lại -> fallback (indent như <Tab> thường).
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<Esc>"] = { "cancel", "fallback" },
      ["<C-b>"] = {
        function(cmp)
          cmp.scroll_documentation_up(4)
        end,
      },
      ["<C-f>"] = {
        function(cmp)
          cmp.scroll_documentation_down(4)
        end,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
            { "source_name" }
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
      },
      list = { selection = { preselect = false, auto_insert = true } },
    },
    signature = {
      enabled = true,
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
    },
    fuzzy = { implementation = "rust" },
  },
  opts_extend = { "sources.default" },
}
