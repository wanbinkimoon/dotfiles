local function get_custom_colors()
	local custom_colors = {}
	custom_colors = {
		tab_active = { fg = "#bd93f9" },
		tab_inactive = { fg = "#6272a4" },
	}
	return custom_colors
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = {
		{ "dokwork/lualine-ex" },
		{ "Mofiqul/dracula.nvim" },
	},
	config = function()
		local custom_colors = get_custom_colors()
		local icons = require("config.icons")
		require("lualine").setup({
			options = {
				-- theme = "dracula-nvim",
				-- theme = "palenight",
				theme = "tokyonight",
				component_separators = "/",
				-- section_separators = { left = "", right = "" },
				section_separators = { left = " ", right = " " },
				-- disabled_filetypes = { "neo-tree" },
				globalstatus = true,
			},
			sections = {
				-- lualine_c = { { "filename", path = 3 } },
				lualine_b = { { "ex.relative_filename", max_length = 0.8 } },
				lualine_c = {
					{
						"diff",
						-- symbols = { added = " ", modified = "󱗝 ", removed = " " },
						symbols = {
							added = icons.git.Add,
							modified = icons.git.Mod,
							removed = icons.git.Remove,
						},
					},
					"diagnostics",
				},
				-- lualine_c = { { "git" }},
				lualine_x = {
					{
						"tabs",
						mode = 1,
						path = 0,
						symbols = { modified = "󱗝" },
						use_mode_colors = true,
						tabs_color = {
							active = { fg = custom_colors.tab_active.fg, bg = custom_colors.tab_active.bg },
							inactive = { fg = custom_colors.tab_inactive.fg },
						},
					},
				},
				lualine_y = { "filetype" },
			},
		})
	end,
}
