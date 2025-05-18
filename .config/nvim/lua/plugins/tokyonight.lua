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
        c["blue"] = "#0a84ff"
        c["cyan"] = "#5ac8f5"
        c["green"] = "#32d74b"
        c["magenta"] = "#ad8ee6"
        c["red"] = "#ff453a"
        c["white"] = "#787c99"
        c["yellow"] = "#ff9f0a"
			end,
			on_highlights = function(hl, c)
				hl.Visual = { bg = c.bg_visual, reverse = true } -- Visual mode selection
				hl.VisualNOS = { bg = c.bg_visual, reverse = true } -- Visual mode selection when vim is "Not Owning the Selection".
				-- hl["@variable"] = { fg = c.yellow, style = config.options.styles.variables }
				-- hl.DiagnosticUnnecessary = { style = "bold,italic,undercurl", bg = c.none, fg = c.none, sp = c.hint }
				-- hl["WinSeparator"] = { bg = "#1F2335", fg = "#565f89", style = "bold" }
				-- hl["@variable"] = { fg = c.yellow }
				-- hl.DiagnosticUnnecessary = { bg = c.none, fg = c.none, sp = c.hint }
				-- hl["WinSeparator"] = { bg = "#1F2335", fg = "#565f89" }
				--
				-- -- hl.TelescopePromptPrefix = { fg = "#A900FF", style = "bold" }
				-- hl.TelescopePromptPrefix = { fg = "#A900FF" }
				-- hl.TelescopeSelectionCaret = { link = "TelescopePromptPrefix" }
				-- hl.IncSearch = { bg = c.warning, fg = c.black }
				-- hl.String = { fg = "#77C469" }
				-- -- hl.Keyword = { fg = "#BE9970", style = config.options.styles.keywords }
				-- hl.Keyword = { fg = "#BE9970" }
				-- -- hl["@module"] = { fg = c.red }
				--
				-- hl["Type"] = { fg = c.hint }
				--
				-- hl["diffAdded"] = { fg = c.hint }
				-- hl["diffChanged"] = { fg = c.warning }
				--
				-- hl["GitSignsAdd"] = { fg = c.hint }
				--
				-- hl["NeoTreeGitUntracked"] = { fg = "#00A300" }
				-- hl["NeoTreeGitUntracked"] = { fg = "#4fd6be" }

        hl["GitSignsAdd"] = { fg = c["green"] }
        hl["GitSignsDelete"] = { fg = c["red"] }
        hl["GitSignsChange"] = { fg = c["yellow"] }
        hl["GitSignsChangedelete"] = { fg = c["red"] }
        hl["GitSignsUntracked"] = { fg = c["white"] }

        hl["SpellBad"] = { bg="#273849" , undercurl = true, sp = "#B8DB87" }

        hl["PmenuSel"] = { bg = c.bg_visual, reverse = true }
        hl["CmpItemAbbrMatch"] = { fg = c.blue }

        hl["WinSeparator"] = { bg = "#1F2335", fg = "#565F89"  }
			end,
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
