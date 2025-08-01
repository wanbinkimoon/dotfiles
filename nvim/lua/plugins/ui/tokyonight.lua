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
			transparent = false,
			on_highlights = function(hl, c)
				hl.WinSeparator = {
					bg = c.bg_dark,
					fg = c.fg_gutter,
				}
				hl.LineNr = {
					fg = c.comment,
				}
				-- hl.CursorLineNr = {
				--   fg = c.blue,
				--   bold = true,
				-- }
				hl.CursorLine = {
					-- bg = "#232838",
					bg = c.bg_highlight,
				}
			end,
		})

		vim.cmd([[colorscheme tokyonight]])
	end,
}
