return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Formatters
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "yaml", "markdown" },
        }),

        -- -- Diagnostics (Linter)
        -- null_ls.builtins.diagnostics.eslint_d.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
        --   end,
        -- }),
        --
        -- -- Optional: Formatting via eslint_d (not recommended if using prettier for formatting)
        -- -- null_ls.builtins.formatting.eslint_d,
      },
    })
  end,
}
