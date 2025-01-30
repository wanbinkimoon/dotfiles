return {
	{
		"Mofiqul/dracula.nvim",
		enabled = true,
		config = function()
			require("dracula").setup({
				transparent_bg = true,
				show_end_of_buffer = true,
				colors = {
					bg = "none",
					half_green = "#273D36", -- Transparent green
					half_cyan = "#2C3E50", -- Transparent cyan
					half_yellow = "#F39C12", -- Transparent yellow
				},
				-- lualine_bg_color = "none",
				italic_comment = true,
				overrides = function(colors)
					return {
						NonText = { fg = colors.white },
						NeoTreeCursorLine = { bg = colors.menu },
						NeoTreeTitleBar = { bg = colors.pink, fg = colors.black },
						NeoTreeFloatBorder = { bg = colors.bg, fg = colors.pink },
						DiffAdd = { bg = colors.half_green },
						DiffChanged = { fg = colors.pink },
						WinSeparator = { fg = colors.gutter_fg },
						TelescopeBorder = { fg = colors.pink },
						TelescopePromptBorder = { fg = colors.pink },
						TelescopePreviewBorder = { fg = colors.pink },
						TelescopeResultsBorder = { fg = colors.pink },
						TelescopeSelection = { bg = colors.comment },
						GitSignsCurrentLineBlame = { fg = colors.comment },
						NeoTreeModified = { fg = colors.orange },
						-- DiagnosticVirtualTextHint = { fg = colors.cyan, bg = colors.half_cyan },
						-- lualine_c_normal = { fg = colors.comment, bg = colors.half_cyan },
					}
				end,
			})

			vim.cmd([[colorscheme dracula]])
			-- vim.cmd([[colorscheme dracula-soft]])
		end,
	},
}
