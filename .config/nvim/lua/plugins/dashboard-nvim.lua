return {
  "nvimdev/dashboard-nvim",
  -- enabled = false,
  lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
  opts = function()
    local logo = [[
         ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
         ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
         ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
         ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
         ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
         ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "Telescope project-manager find_dirs cwd=~/Desktop/ hidden=true no_ignore=true",       desc = " Find Folder in Desktop",       icon = "  ", key = "<D-d>" },
          -- { action = "Telescope project-manager live_find_dirs cwd=~/Desktop/ hidden=true no_ignore=true",  desc = " Live Find Folder in Desktop",  icon = "  ", key = "<D-f>" },
          { action = "Telescope project-manager find_files cwd=~/Desktop/ hidden=true no_ignore=true", desc = " Find File in Desktop",   icon = "  󰈙", key = "<D-f>" },
          { action = "Telescope project-manager find_files hidden=true no_ignore=true",                desc = " Find File",    icon = "  󰈙 ", key = "f" },
          { action = "ene | startinsert",                               desc = " New File",     icon = "    ", key = "n" },
          -- { action = "Telescope oldfiles",                             desc = " Recent Files",    icon = " ", key = "r" },
          -- { action = "Telescope project-manager live_grep hidden=true no_ignore=true",                            desc = "  Find Text",       icon = " ", key = "g" },
          { action = 'lua LazyVim.pick.config_files()()',               desc = " Config",       icon = "    ", key = "c" },
          -- { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
          { action = "LazyExtras",                                      desc = " Lazy Extras",  icon = "    ", key = "x" },
          { action = "Lazy",                                            desc = " Lazy",         icon = "  󰒲  ", key = "l" },
          { action = function() vim.api.nvim_input("<cmd>qa<cr>") end,  desc = " Quit",         icon = "    ", key = "q" },
       },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return opts
  end,
}
