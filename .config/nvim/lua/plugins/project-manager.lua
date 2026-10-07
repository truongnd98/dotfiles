return {
	"truongnd98/project-manager.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope.nvim",
	},
	-- `keys = {}` rỗng đã xoá (nó không lazy-load gì cả vì `event = "VeryLazy"`
	-- phía dưới mới là thứ quyết định). Plugin dùng qua `:Telescope
	-- project-manager ...`; muốn có phím thì thêm vào `keys` và bỏ `event`.
	config = function()
		require("project-manager").setup({
			fd = {
				default_exclude = {
					-- default
					"node_modules",
					".git",
					".DS_Store",
				},
			},
			eza = {
				default_exclude = {
					-- default
					"node_modules",
					".git",
					".DS_Store",
				},
			},
			rg = {
				default_exclude = {
					-- default
					"node_modules",
					".git",
					".DS_Store",
				},
			},
			highlights = {
				finder_folder_icon_default = {
					name = "PMFinderFolderIconDefault",
					fg = "#3270F3",
					bg = "",
				},
				finder_folder_icon_empty = {
					name = "PMFinderFolderIconEmpty",
					fg = "#7AA2F7",
					bg = "",
				},
				finder_folder_path = {
					name = "PMFinderFolderPath",
					fg = "",
					bg = "",
				},
				finder_filter_matching = {
					name = "PMFinderFilterMatching",
					fg = "#FF6E18",
					bg = "",
				},
				previewer_folder_icon = {
					name = "PMPreviewerFolderIcon",
					fg = "#7AA2F7",
					bg = "",
				},
				previewer_folder_name = {
					name = "PMPreviewerFolderName",
					fg = "#7AA2F7",
					bg = "",
					bold = true,
				},
				previewer_file_name = {
					name = "PMPreviewerFileName",
					fg = "#E0AF68",
					bg = "",
				},
				previewer_tree_indent = {
					name = "PMPreviewerTreeIndent",
					fg = "#7AA2F7",
					bg = "",
				},
				previewer_tree_root_path = {
					name = "PMPreviewerTreeRootPath",
					fg = "#7AA2F7",
					bg = "",
					bold = true,
				},
			},
		})
	end,
	event = "VeryLazy",
}
