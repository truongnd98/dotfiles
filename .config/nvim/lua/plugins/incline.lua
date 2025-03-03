return {
	"b0o/incline.nvim",
	-- enabled = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local devicons = require("nvim-web-devicons")
		require("incline").setup({
			hide = { cursorline = true },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

				if filename == "neo-tree filesystem [1]" then
					return
				end

				if filename == "" then
					filename = "[no name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)

				local function get_git_diff()
					local icons = { added = "", changed = "", removed = "" }
					local signs = vim.b[props.buf].gitsigns_status_dict
					local labels = {}
					if signs == nil then
						return labels
					end
					for name, icon in pairs(icons) do
						if tonumber(signs[name]) and signs[name] > 0 then
							table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "diff" .. name })
						end
					end
					if #labels > 0 then
						table.insert(labels, { "┊ ", group = labels[#labels].group })
					end
					return labels
				end

				local function get_diagnostic_label() -- 󰋽
					local icons = { error = "", warn = "", info = "", hint = "" }
					local labels = {}

					for severity, icon in pairs(icons) do
						local n = #vim.diagnostic.get(
							props.buf,
							{ severity = vim.diagnostic.severity[string.upper(severity)] }
						)
						if n > 0 then
							table.insert(labels, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
						end
					end
					if #labels > 0 then
						table.insert(labels, { "┊ ", group = labels[#labels].group })
					end
					return labels
				end

				return {
					{ get_diagnostic_label() },
					{ get_git_diff() },
					{ (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
					{
						filename .. (vim.bo[props.buf].modified and "[modified]" or "") .. " ",
						gui = vim.bo[props.buf].modified and "bold,italic" or "bold",
					},
					{
						"┊  " .. vim.api.nvim_win_get_number(props.win) .. "| " .. props.buf,
						guifg = "#00A4EF",
						gui = "bold",
					},
				}
			end,
		})
	end,
	-- -- optional: lazy load incline
	event = "VeryLazy",
}
