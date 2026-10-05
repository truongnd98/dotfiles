-- nvim-treesitter `main` branch: setup() only takes `install_dir`.
-- Parsers are installed with `install()`, highlighting/indent/folding are
-- turned on per-buffer via the FileType autocmd below.
local ensure_installed = {
  -- core
  "lua",
  "vim",
  "vimdoc",
  "query",
  "bash",
  "regex",
  "diff",
  "gitcommit",
  "git_rebase",
  -- go
  "go",
  "gomod",
  "gosum",
  "gowork",
  "gotmpl",
  -- rust
  "rust",
  "toml",
  "ron",
  -- web
  "javascript",
  "typescript",
  "tsx",
  -- data / docs
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "sql",
  "proto",
  "dockerfile",
  "make",
}

-- Don't attach treesitter to files big enough that parsing hurts more than it helps.
local MAX_FILESIZE = 512 * 1024

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    priority = 500,
    config = function()
      require("nvim-treesitter").setup({})

      local installed = {}
      for _, lang in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
        installed[lang] = true
      end

      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, ensure_installed)

      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      -- MDX
      vim.filetype.add({ extension = { mdx = "mdx" } })
      vim.treesitter.language.register("markdown", { "mdx", "MD" })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter.start", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end

          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
          if ok and stats and stats.size > MAX_FILESIZE then
            return
          end

          if not pcall(vim.treesitter.start, ev.buf, lang) then
            return
          end

          -- `foldexpr` is global (see config/options.lua); indent is opt-in per buffer.
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- af/if = function, ac/ic = class|struct, aa/ia = parameter, a?/i? = block
      local textobjects = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["a/"] = "@comment.outer",
        ["i/"] = "@comment.inner",
      }
      for lhs, query in pairs(textobjects) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "Select " .. query })
      end

      -- ]f/[f function, ]c/[c class|struct, ]a/[a parameter
      local moves = {
        ["]f"] = { move.goto_next_start, "@function.outer" },
        ["]F"] = { move.goto_next_end, "@function.outer" },
        ["]c"] = { move.goto_next_start, "@class.outer" },
        ["]a"] = { move.goto_next_start, "@parameter.inner" },
        ["[f"] = { move.goto_previous_start, "@function.outer" },
        ["[F"] = { move.goto_previous_end, "@function.outer" },
        ["[c"] = { move.goto_previous_start, "@class.outer" },
        ["[a"] = { move.goto_previous_start, "@parameter.inner" },
      }
      for lhs, spec in pairs(moves) do
        local goto_fn, query = spec[1], spec[2]
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          goto_fn(query, "textobjects")
        end, { desc = "Goto " .. query })
      end

      -- Reorder function arguments / struct fields without leaving normal mode.
      vim.keymap.set("n", "<leader>ma", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>mA", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })
    end,
  },
}
