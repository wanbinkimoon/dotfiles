return {
	"folke/tokyonight.nvim",
	enabled = true,
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("tokyonight").setup({
			-- colorscheme tokyonight-night
			-- colorscheme tokyonight-storm
			-- colorscheme tokyonight-day
			-- colorscheme tokyonight-moon
			style = "moon",
			hide_inactive_statusline = true,
			transparent = true,
			on_highlights = function(hl, c)
				hl.WinSeparator = {
					bg = c.bg_dark,
					fg = c.fg_gutter,
				}
			end,
		})

		vim.cmd([[colorscheme tokyonight]])
	end,
}
