return {
	-- {
	-- 	"folke/zen-mode.nvim",
	-- 	cmd = "ZenMode",
	-- 	opts = {
	-- 		-- plugins = {
	-- 		-- 	gitsigns = true,
	-- 		-- 	tmux = true,
	-- 		-- 	kitty = { enabled = false, font = "+2" },
	-- 		-- },
	-- 	},
	-- 	keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
	-- },
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,

      -- legacy_computing_symbols_support = true,
      distance_stop_animating_vertical_bar = 0.1,
    },
  },
}
