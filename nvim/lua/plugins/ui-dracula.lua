return {
	{
		"Mofiqul/dracula.nvim",
		config = function()
			require("dracula").setup({
				transparent_bg = true,
				show_end_of_buffer = true,
				overrides = function(colors)
					return {
						NonText = { fg = colors.white },
						NvimTreeIndentMarker = { fg = colors.pink },
					}
				end,
			})
			vim.cmd([[colorscheme dracula]])
		end,
	},
}
