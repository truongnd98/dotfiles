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
    -- enabled = vim.env.TMUX == nil,
    opts = {
      -- legacy_computing_symbols_support = true,
      -- distance_stop_animating_vertical_bar = 0.5,
      distance_stop_animating_vertical_bar = 0.1,
      smear_to_cmd = false,

      -- cursor_color = "#ff6767",
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,

      -- trailing_exponent = 2,
      trailing_exponent = 0.5,
      damping = 0.7,
      gradient_exponent = 0,
      gamma = 1,
      never_draw_over_target = true,
      hide_target_hack = true,

      matrix_pixel_threshold = 0.5,

      -- NORMAL mode setting
      -- vertical_bar_cursor = true,
      vertical_bar_cursor = false,

      -- INSERT mode setting
      smear_insert_mode = true,
      stiffness_insert_mode = 0.25,
      trailing_stiffness_insert_mode = 0.25,
      damping_insert_mode = 0.9,
    },
  },
}
