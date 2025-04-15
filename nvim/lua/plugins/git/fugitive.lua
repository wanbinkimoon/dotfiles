return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
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
			vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7dcfff" }) -- Cyan/Blue
			vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e" }) -- Red
			vim.api.nvim_set_hl(0, "GitSignsTopdelete", { link = "GitSignsDelete" })
			vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
			vim.api.nvim_set_hl(0, "GitSignsUntracked", { link = "GitSignsAdd" })
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiffsplit" }, -- Load on demand
		keys = {
			{ "gs", "<cmd>:Git<CR>", desc = "[G]it: open git status" },
			{ "gB", "<cmd>:Git blame<CR>", desc = "[G]it: blame", { noremap = true } },
			{ "gd", "<cmd>:Gdiff<CR>", desc = "[G]it: diff" },
			{ "gD", "<cmd>:Gdiffsplit<CR>", desc = "[G]it: diff split" },
			{ "gk", "<cmd>:diffget //3<CR>", desc = "[G]it: diff get from right" },
			{ "gj", "<cmd>:diffget //2<CR>", desc = "[G]it: diff get from left" },
			{ "gv", "<cmd>DiffviewOpen<CR>", desc = "[G]it: open diff view" },
			{ "gc", "<cmd>DiffviewClose<CR>", desc = "[G]it: close diff view" },
		},
		config = function()
			vim.g.fugitive_git_command = "git"
			vim.g.fugitive_blame_line_relativenumber = 1
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("diffview").setup({
				view = {
					default = {
						layout = "diff2_horizontal", -- Horizontal diff layout
					},
					merge_tool = {
						layout = "diff3_horizontal", -- Horizontal 3-way merge view
					},
				},
				file_panel = {
					listing_style = "tree", -- One of 'list' or 'tree'
					tree_options = { -- Only applicable when listing_style is 'tree'
						flatten_dirs = true,
						folder_statuses = "always",
					},
				},
			})
		end,
	},
}
