return {
	-- -- Create annotations with one keybind, and jump your cursor in the inserted annotation
	-- {
	-- 	"danymat/neogen",
	-- 	keys = {
	-- 		{
	-- 			"<leader>gc",
	-- 			function()
	-- 				require("neogen").generate({})
	-- 			end,
	-- 			desc = "Neogen Comment",
	-- 		},
	-- 	},
	-- 	opts = { snippet_engine = "luasnip" },
	-- },

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

	-- -- Go forward/backward with square brackets
	-- {
	-- 	"echasnovski/mini.bracketed",
	-- 	event = "BufReadPost",
	-- 	config = function()
	-- 		local bracketed = require("mini.bracketed")
	-- 		bracketed.setup({
	-- 			file = { suffix = "" },
	-- 			window = { suffix = "" },
	-- 			quickfix = { suffix = "" },
	-- 			yank = { suffix = "" },
	-- 			treesitter = { suffix = "n" },
	-- 		})
	-- 	end,
	-- },

	-- -- Better increase/descrease
	-- {
	-- 	"monaqa/dial.nvim",
	--    -- stylua: ignore
	--    keys = {
	--      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
	--      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
	--    },
	-- 	config = function()
	-- 		local augend = require("dial.augend")
	-- 		require("dial.config").augends:register_group({
	-- 			default = {
	-- 				augend.integer.alias.decimal,
	-- 				augend.integer.alias.hex,
	-- 				augend.date.alias["%Y/%m/%d"],
	-- 				augend.constant.alias.bool,
	-- 				augend.semver.alias.semver,
	-- 				augend.constant.new({ elements = { "let", "const" } }),
	-- 			},
	-- 		})
	-- 	end,
	-- },
	--
	-- {
	-- 	"simrat39/symbols-outline.nvim",
	-- 	keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
	-- 	cmd = "SymbolsOutline",
	-- 	opts = {
	-- 		position = "right",
	-- 	},
	-- },

	{
		"nvim-cmp",
		-- enabled = false,
		-- dependencies = { "hrsh7th/cmp-emoji" },
		opts = function(_, opts)
			-- -- table.insert(opts.sources, { name = "emoji" })
			-- local cmp = require("cmp")
			-- opts.mapping = cmp.mapping.preset.insert({
			-- 	["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
			-- 	["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
			-- 	["<C-b>"] = cmp.mapping.scroll_docs(-4),
			-- 	["<C-f>"] = cmp.mapping.scroll_docs(4),
			-- 	["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
			-- 	["<C-e>"] = cmp.mapping.abort(), -- close completion window
			-- 	["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
			-- 	["<Tab>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
			-- })
		end,
	},
}
