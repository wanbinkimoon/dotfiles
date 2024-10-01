return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		{ "dokwork/lualine-ex" },
	},
	config = function()
		local dracula = require("dracula").colors()

		require("lualine").setup({
			options = {
				theme = "dracula",
				component_separators = "/",
				section_separators = { left = "", right = "" },
				-- disabled_filetypes = { "neo-tree" },
				globalstatus = true,
			},
			sections = {
				-- lualine_c = { { "filename", path = 3 } },
				lualine_c = { { "ex.relative_filename", max_length = 0.8 } },
				lualine_x = {
					"filetype",
					{
						"tabs",
						mode = 1,
						path = 0,
						symbols = { modified = "󱗝" },
						use_mode_colors = true,
						tabs_color = {
							active = { fg = dracula.purple },
							inactive = { fg = dracula.fg },
						},
					},
				},
				lualine_y = { "encoding" },
			},
		})
	end,
}
