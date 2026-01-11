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
      -- legacy_computing_symbols_support = true,
      distance_stop_animating_vertical_bar = 0.1,

      cursor_color = "#a277ff",
      stiffness = 0.5,
      trailing_stiffness = 0.2,
      trailing_exponent = 5,
      damping = 0.85,
      gradient_exponent = 0,
      gamma = 1,
      never_draw_over_target = true,
      hide_target_hack = true,
    },
  },
}
