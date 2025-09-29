return {
	{
		"nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
		opts = {
      auto_install = true,
			ensure_installed = {
				"lua",
				"vim",
				"javascript",
				"typescript",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"json",
        "markdown",
        "markdown_inline",
			},
      sync_install = false,
			highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
			indent = {
        enable = true,
      },
      incremental_selection = {
        enable = false,
      },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)

			-- MDX
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}
