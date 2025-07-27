return {
  "saghen/blink.cmp",
  enabled = false,
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = {
      preset = "luasnip",
      -- search_paths = { vim.g.vscode_snippets_path },
    },
    keymap = {
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
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
        auto_show_delay_ms = 0,
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
  },
  opts_extend = { "sources.default" },
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      -- version = "v2.*",
      build = "make install_jsregexp",
      opts = { history = true, delete_check_events = "TextChanged" },
    },
    "tamago324/nlsp-settings.nvim",
  },
}
