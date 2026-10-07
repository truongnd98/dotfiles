return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- add this plugin as dependency for lualine
    "bwpge/lualine-pretty-path",
  },
  -- Khối `init` cũ (ẩn statusline rồi khôi phục qua vim.g.lualine_laststatus)
  -- đã xoá: nó là pattern của LazyVim để tránh nháy statusline trên trang
  -- dashboard - config này không có dashboard/alpha/starter nào.
  opts = function()
    local opts = {
      options = {
        theme = "auto",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = vim.o.laststatus == 3,
        -- `disabled_filetypes = { "dashboard", "alpha", "ministarter" }` đã xoá:
        -- không plugin nào trong số đó được cài.
        --
        -- refresh 300ms -> 1000ms: thứ duy nhất cần nhịp nhanh ở đây là đồng hồ
        -- trong lualine_z, mà nó chỉ hiện tới phút. 300ms nghĩa là vẽ lại
        -- statusline hơn 3 lần/giây vĩnh viễn.
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
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
              hint = "",
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
