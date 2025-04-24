return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "┃" },
				topdelete = { text = "┃" },
				changedelete = { text = "┃" },
				untracked = { text = "┃" },
			},
			signcolumn = true,
			update_debounce = 200,
			max_file_length = 40000,
			current_line_blame = true, -- Disabled by default, toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_formatter = "<author>, <author_time:%R> - <abbrev_sha> - <summary>",
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
		})
		-- TokyoNight Storm colors
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a" }) -- Green
		-- vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7dcfff" }) -- Cyan/Blue
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e" }) -- Red
		vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
		vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
		vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GitSignsAdd" })
	end,
}
