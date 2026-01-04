return {
	-- Incremental rename
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		config = function()
			require("inc_rename").setup({})
			vim.keymap.set("n", "<leader>rn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
		event = "VeryLazy",
	},
  {
    "kylechui/nvim-surround",
    version = "*", -- Use "master" for latest features, "*" for stable releases
    config = function()
      require("nvim-surround").setup()
    end,
    event = "VeryLazy",
  },
}
