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
    require("project-manager").setup({})
  end,
}
