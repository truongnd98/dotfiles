return {
  "truongnd98/project-manager.nvim",
  -- enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-tree.lua",
  },
  config = function()
    require("project-manager").setup({
      fd = {
        default_exclude = {
          -- default
          "node_modules",
          "*/ios/Runner*",
          "*/macos/Runner*",
          "*/ios/Pods*",
          "*/macos/Pods*",
          "*/build/ios*",
          "*/build/macos*",
        },
      },
    })
  end,
}
