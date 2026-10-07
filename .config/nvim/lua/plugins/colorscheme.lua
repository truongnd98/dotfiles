return {
  -- {
  --   "baliestri/aura-theme"},
  --   lazy = false,
  --   priority = 1000,
  --   config = function(plugin)
  --     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
  --     vim.cmd([[colorscheme aura-dark]])
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  --   end,
  -- },
  {
    "ray-x/aurora",
    -- `lazy = false` + `priority = 1000`: priority mặc định là 50, trong khi
    -- nvim-treesitter đặt 500. Không có dòng này thì treesitter load TRƯỚC
    -- colorscheme và mọi highlight group plugin set sẽ bị `colorscheme aurora`
    -- xoá sạch, kèm một nháy màu mặc định lúc khởi động.
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.aurora_italic = 1
      vim.g.aurora_transparent = 1
      vim.g.aurora_bold = 1
    end,
    config = function()
      -- Đặt override trong autocmd ColorScheme thay vì gọi thẳng: `:colorscheme`
      -- reset toàn bộ highlight, nên nếu set một lần ở đây thì mỗi lần
      -- re-source colorscheme (hoặc plugin nào đó gọi lại) là mất override.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("colorscheme.overrides", { clear = true }),
        pattern = "aurora",
        callback = function()
          vim.api.nvim_set_hl(0, "@number", { fg = "#e933e3" })

          -- Visual mode selection highlight
          vim.api.nvim_set_hl(0, "Visual", { bg = "#44475a", reverse = true })
          vim.api.nvim_set_hl(0, "VisualNOS", { bg = "#44475a", reverse = true })
        end,
      })

      vim.cmd.colorscheme("aurora")
    end
  }
}
