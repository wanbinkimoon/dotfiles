local function get_custom_colors()
	local custom_colors = {}
	if pcall(require, "draclua") then
		local dracula = require("draclua").colors()
		custom_colors = {
			tab_active = { fg = dracula.purple },
			tab_inactive = { fg = dracula.fg },
		}
	elseif pcall(require, "tokyonight") then
		local tokyonight = require("tokyonight.colors").setup()
		custom_colors = {
			tab_active = { fg = tokyonight.fg },
			tab_inactive = { fg = tokyonight.fg_dark },
		}
	else
		custom_colors = {
			tab_active = { fg = "#bd93f9" },
			tab_inactive = { fg = "#6272a4" },
		}
	end
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
		require("lualine").setup({
			options = {
				-- theme = "dracula-nvim",
				theme = "palenight",
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
							active = { fg = custom_colors.tab_active.fg },
							inactive = { fg = custom_colors.tab_inactive.fg },
						},
					},
				},
				lualine_y = { "encoding" },
			},
		})
	end,
}
