return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- add this plugin as dependency for lualine
    "bwpge/lualine-pretty-path",
  },
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
        refresh = {
          statusline = 300,
          tabline = 300,
          winbar = 300,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          {
            "diagnostics",
            update_in_insert = true,
            separator = "",
            padding = { left = 1, right = 0 },
            fmt = function (display)
              if #display > 0 then
                return display .. " ┊"
              end
            end,
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              -- hint = " ",
            },
          },
          {
            "diff",
            separator = "",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = function ()
              local buf = vim.api.nvim_get_current_buf()
              local signs = vim.b[buf].gitsigns_status_dict

              local results = {}
              if signs == nil then
                return results
              end

              results = {
                added = signs["added"] or 0,
                modified = signs["changed"] or 0,
                removed = signs["removed"] or 0,
              }

              return results
            end,
          },
          {"pretty_path"}
        },
        lualine_x = {
          {
            "encoding",
            color = {
              fg = "#FF453A",
            },
          },
          "filetype"
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = {},
    }

    return opts
  end,
}
