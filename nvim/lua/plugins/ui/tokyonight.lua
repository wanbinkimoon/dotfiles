return {
	"folke/tokyonight.nvim",
	enabled = false,
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		-- Borderless Telescope
		require("tokyonight").setup({
			on_highlights = function(hl, c)
				hl.WinSeparator = {
					bg = c.bg_dark,
					fg = c.fg_gutter,
				}
			end,
		})

		vim.cmd([[colorscheme tokyonight-night]])
		-- vim.cmd([[colorscheme tokyonight-storm]])
		-- vim.cmd([[colorscheme tokyonight-day]])
		-- vim.cmd([[colorscheme tokyonight-moon]])

		-- " There are also colorschemes for the different styles.
		-- colorscheme tokyonight-night
		-- colorscheme tokyonight-storm
		-- colorscheme tokyonight-day
		-- colorscheme tokyonight-moon
	end,
}
