return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gdiffsplit" }, -- Load on demand
		dependencies = {
			"lewis6991/gitsigns.nvim", -- Adds git decorations and inline blame
			"sindrets/diffview.nvim", -- Enhanced diff view similar to VSCode
		},
		keys = {
			{ "gs", "<cmd>:Git<CR>", desc = "[G]it: open git status" },
			{ "gb", "<cmd>:Git blame<CR>", desc = "[G]it: blame" },
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

			-- Gitsigns configuration for inline git decorations
			require("gitsigns").setup({
				signs = {
					-- add = { text = "+" },
					-- change = { text = "~" },
					-- delete = { text = "_" },
					-- topdelete = { text = "‾" },
					-- changedelete = { text = "~" },
				},
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
			})
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
