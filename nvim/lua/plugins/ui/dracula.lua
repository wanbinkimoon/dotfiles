return {
	{
		"Mofiqul/dracula.nvim",
		config = function()
			require("dracula").setup({
				transparent_bg = true,
				show_end_of_buffer = true,
				colors = {
					bg = "none",
					semi_transparent_green = "#273D36", -- Transparent green
				},
				lualine_bg_color = "none",
				italic_comment = true,
				overrides = function(colors)
					return {
						NonText = { fg = colors.white },
						NeoTreeCursorLine = { bg = colors.menu },
						NeoTreeTitleBar = { bg = colors.pink, fg = colors.black },
						NeoTreeFloatBorder = { bg = colors.bg, fg = colors.pink },
						DiffAdd = { bg = colors.semi_transparent_green },
						DiffChanged = { fg = colors.pink },
						WinSeparator = { fg = colors.gutter_fg },
						TelescopeBorder = { fg = colors.pink },
						TelescopePromptBorder = { fg = colors.pink },
						TelescopePreviewBorder = { fg = colors.pink },
						TelescopeResultsBorder = { fg = colors.pink },
						GitSignsCurrentLineBlame = { fg = colors.comment },
					}
				end,
			})

			vim.cmd([[colorscheme dracula]])
		end,
	},
}
