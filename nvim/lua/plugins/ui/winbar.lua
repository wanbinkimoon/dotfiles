return {
	{
		"ramilito/winbar.nvim",
		event = "BufReadPre",
		lazy = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local icons = require("config.icons")
			require("winbar").setup({
				-- your configuration comes here, for example:
				icons = true,
				filetype_exclude = {
					"help",
					"startify",
					"dashboard",
					"packer",
					"neo-tree",
					"neogitstatus",
					"NvimTree",
					"Trouble",
					"alpha",
					"lir",
					"Outline",
					"spectre_panel",
					"toggleterm",
					"TelescopePrompt",
					"prompt",
				},
				diagnostics = true,
				buf_modified = true,
				dir_levels = 3,
				buf_modified_symbol = icons.git.Mod,
				dim_inactive = {
					enabled = false,
					highlight = "WinBarNC",
					icons = true, -- whether to dim the icons
					name = true, -- whether to dim the name
				},
			})
		end,
	},
}
