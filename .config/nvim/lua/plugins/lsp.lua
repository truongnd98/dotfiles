return {
  {
    "williamboman/mason.nvim",
    -- enabled = false,
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- enabled = false,
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    -- enabled = false,
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- lua
      vim.lsp.enable("lua_ls")
      vim.lsp.config["lua_ls"] = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
      -- typescript
      vim.lsp.enable("ts_ls")
      vim.lsp.config["ts_ls"] = {
        capabilities = capabilities,
      }
      -- Js
      vim.lsp.enable("eslint")
      -- yaml
      vim.lsp.enable("yamlls")
      -- golang
      vim.lsp.enable("gopls")
      vim.lsp.config["gopls"] = {
        capabilities = capabilities,
      }
      -- golangci lint
      vim.lsp.enable("golangci_lint_ls")
      -- lsp kepmap setting
      vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
      -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      -- -- list all methods in a file
      -- -- working with go confirmed, don't know about other, keep changing as necessary
      -- vim.keymap.set("n", "<leader>fm", function()
      --   local filetype = vim.bo.filetype
      --   local symbols_map = {
      --     javascript = "function",
      --     typescript = "function",
      --     lua = "function",
      --     go = { "method", "struct", "interface" },
      --   }
      --   local symbols = symbols_map[filetype] or "function"
      --   require("telescope.builtin").lsp_document_symbols({ symbols = symbols })
      -- end, {})
    end
  }
}
