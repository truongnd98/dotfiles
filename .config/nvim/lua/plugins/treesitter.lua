return {
	{
		"nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    build = ":TSUpdate",
		opts = {
      auto_install = true,
			ensure_installed = {
  			"c",
				"lua",
				"vim",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"json",
			},
      sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- -- MDX
			-- vim.filetype.add({
			-- 	extension = {
			-- 		mdx = "mdx",
			-- 	},
			-- })
			-- vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
