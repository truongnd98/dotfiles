return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
    enabled = false,
		cmd = "IncRename",
		config = function()
			require("inc_rename").setup({})
			vim.keymap.set("n", "<leader>rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
		event = "VeryLazy",
	},

	-- -- Refactoring tool
	-- {
	-- 	"ThePrimeagen/refactoring.nvim",
	-- 	keys = {
	-- 		{
	-- 			"<leader>r",
	-- 			function()
	-- 				require("refactoring").select_refactor()
	-- 			end,
	-- 			mode = "v",
	-- 			noremap = true,
	-- 			silent = true,
	-- 			expr = false,
	-- 		},
	-- 	},
	-- 	opts = {},
	-- },
}
