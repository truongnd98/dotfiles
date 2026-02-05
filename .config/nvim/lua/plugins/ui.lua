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
    enabled = vim.env.TMUX == nil,
    opts = {
      -- legacy_computing_symbols_support = true,
      distance_stop_animating_vertical_bar = 0.5,

      cursor_color = "#a277ff",
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      trailing_exponent = 2,
      damping = 0.7,
      gradient_exponent = 0,
      gamma = 1,
      never_draw_over_target = true,
      hide_target_hack = true,
    },
  },
}
