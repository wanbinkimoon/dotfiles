return {
	{
		"Mofiqul/dracula.nvim",
		config = function()
			require("dracula").setup({
				transparent_bg = true,
				show_end_of_buffer = true,
				colors = {
					bg = "none",
				},
				lualine_bg_color = "none",
				italic_comment = true,
				overrides = function(colors)
					return {
						NonText = { fg = colors.white },
						NeoTreeCursorLine = { bg = colors.menu },
						NeoTreeTitleBar = { bg = colors.pink, fg = colors.black },
						NeoTreeFloatBorder = { bg = colors.bg, fg = colors.pink },
					}
				end,
			})

			vim.cmd([[colorscheme dracula]])
		end,
	},
}
