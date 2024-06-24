local highlight = {
	"RainbowColor3",
	"RainbowColor4",
	"RainbowColor5",
	"RainbowColor6",
	"RainbowColor7",
	"RainbowColor1",
	"RainbowColor2",
}

local highlightScope = {
	"RainbowColorScope3",
	"RainbowColorScope2",
	"RainbowColorScope1",
	"RainbowColorScope7",
	"RainbowColorScope6",
	"RainbowColorScope5",
	"RainbowColorScope4",
}

local set_hl = vim.api.nvim_set_hl

local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	set_hl(0, "RainbowColor1", { fg = "#674865" })
	set_hl(0, "RainbowColor2", { fg = "#686366" })
	set_hl(0, "RainbowColor3", { fg = "#456086" })
	set_hl(0, "RainbowColor4", { fg = "#645662" })
	set_hl(0, "RainbowColor5", { fg = "#546365" })
	set_hl(0, "RainbowColor6", { fg = "#625083" })
	set_hl(0, "RainbowColor7", { fg = "#436178" })

	set_hl(0, "RainbowColorScope1", { fg = "#E06C75" })
	set_hl(0, "RainbowColorScope2", { fg = "#E5C07B" })
	set_hl(0, "RainbowColorScope3", { fg = "#61AFEF" })
	set_hl(0, "RainbowColorScope4", { fg = "#D19A66" })
	set_hl(0, "RainbowColorScope5", { fg = "#98C379" })
	set_hl(0, "RainbowColorScope6", { fg = "#C678DD" })
	set_hl(0, "RainbowColorScope7", { fg = "#56B6C2" })
end)

return {
	"lukas-reineke/indent-blankline.nvim",
	-- enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	opts = function(_, opts)
		opts = {
			indent = {
				-- char = "+",
				-- tab_char = "⇥",
				-- char = "▏",
				-- tab_char = "▏",
				char = "┊",
				tab_char = "┊",
				highlight = highlight,
				priority = 2,
			},
			whitespace = {
				highlight = highlight,
				remove_blankline_trail = false,
			},
			scope = {
				highlight = highlightScope,
				enabled = true,
			},
		}

		return opts
	end,
}
