return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		local config = require("tokyonight.config")

		require("tokyonight").setup({
			on_colors = function(c)
        c["black"] = "#1C1C1E"
        c["blue"] = "#0A84FF"
        c["cyan"] = "#64D2FF"
        c["green"] = "#30D158"
        c["purple"] = "#BF5AF2"
        c["magenta"] = "#AD8EE6"
        c["red"] = "#FF453A"
        c["white"] = "#FFFFFF"
        c["yellow"] = "#FFD60A"
        c["orange"] = "#FF9F0A"

			end,
			on_highlights = function(hl, c)
				hl.Visual = { bg = c.bg_visual, reverse = true } -- Visual mode selection
				hl.VisualNOS = { bg = c.bg_visual, reverse = true } -- Visual mode selection when vim is "Not Owning the Selection".

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
