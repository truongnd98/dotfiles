return {
	"folke/tokyonight.nvim",
	-- enabled = false,
	priority = 1000,
	config = function()
		local config = require("tokyonight.config")

		require("tokyonight").setup({
			-- style = "moon",

			on_colors = function(c)
				c["black"] = "#32344a"
				c["blue"] = "#4a80f4"
				c["cyan"] = "#00e6e6"
				c["green"] = "#00A300"
				c["magenta"] = "#ad8ee6"
				c["red"] = "#f7768e"
				c["white"] = "#787c99"
				c["yellow"] = "#ff9e64"
			end,

			on_highlights = function(hl, c)
				hl.Visual = { bg = c.bg_visual, reverse = true } -- Visual mode selection
				hl.VisualNOS = { bg = c.bg_visual, reverse = true } -- Visual mode selection when vim is "Not Owning the Selection".
				-- hl["@variable"] = { fg = c.yellow, style = config.options.styles.variables }
				-- hl.DiagnosticUnnecessary = { style = "bold,italic,undercurl", bg = c.none, fg = c.none, sp = c.hint }
				-- hl["WinSeparator"] = { bg = "#1F2335", fg = "#565f89", style = "bold" }
				hl["@variable"] = { fg = c.yellow }
				hl.DiagnosticUnnecessary = { bg = c.none, fg = c.none, sp = c.hint }
				hl["WinSeparator"] = { bg = "#1F2335", fg = "#565f89" }

				-- hl.TelescopePromptPrefix = { fg = "#A900FF", style = "bold" }
				hl.TelescopePromptPrefix = { fg = "#A900FF" }
				hl.TelescopeSelectionCaret = { link = "TelescopePromptPrefix" }
				hl.IncSearch = { bg = c.warning, fg = c.black }
				hl.String = { fg = "#77C469" }
				-- hl.Keyword = { fg = "#BE9970", style = config.options.styles.keywords }
				hl.Keyword = { fg = "#BE9970" }
				hl["@module"] = { fg = c.red }

				hl["Type"] = { fg = c.hint }

				hl["diffAdded"] = { fg = c.hint }
				hl["diffChanged"] = { fg = c.warning }

				hl["GitSignsAdd"] = { fg = c.hint }

				hl["NeoTreeGitUntracked"] = { fg = "#00A300" }
			end,
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
