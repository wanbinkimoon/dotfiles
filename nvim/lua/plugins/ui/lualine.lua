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
	event = "VeryLazy",
	config = function()
		local custom_colors = get_custom_colors()
		local icons = require("config.icons")
		local function isRecording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return "recording to " .. reg
		end

		require("lualine").setup({
			options = {
				theme = "tokyonight",
				component_separators = "/",
				section_separators = { left = " ", right = " " },
				globalstatus = true,
			},
			sections = {
				lualine_b = { { "filename", path = 0 } },
				lualine_c = {
					{
						"diff",
						symbols = {
							added = icons.git.Add,
							modified = icons.git.Mod,
							removed = icons.git.Remove,
						},
					},
					"diagnostics",
					{
						function()
							return vim.ui.progress_status() or ""
						end,
					},
				},
				lualine_x = {
					isRecording,
					{
						"tabs",
						mode = 3,
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
