return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		---@type snacks.Config
		opts = {
			picker = {
				ui_select = true,
				prompt = "   ",
				layout = {
					preset = "vertical",
					layout = {
						width = 0.75,
						height = 0.85,
					},
				},
				sources = {
					files = { hidden = true },
					grep = { hidden = true },
					smart = {
						multi = { "buffers", "recent", "files" },
						format = "file",
					},
				},
				formatters = {
					file = {
						truncate = "center",
						filename_first = false,
					},
				},
				matcher = {
					sort_empty = false,
					frecency = true,
				},
				win = {
					input = {
						keys = {
							["<C-p>"] = { "toggle_preview", mode = { "i", "n" } },
							["<C-c>"] = { "cancel", mode = { "i", "n" } },
							["<M-Up>"] = { "history_back", mode = { "i", "n" } },
							["<M-Down>"] = { "history_forward", mode = { "i", "n" } },
						},
					},
				},
			},
		},
		keys = {
			-- Smart & Resume
			{ "<leader>ss", function() Snacks.picker.smart() end, desc = "[S]earch: [S]mart" },
			{ "<leader><leader>", function() Snacks.picker.resume() end, desc = "[S]earch: Resume" },

			-- Files & Text
			{ "<leader>sf", function() Snacks.picker.files() end, desc = "[S]earch: [F]iles" },
			{ "<leader>sg", function() Snacks.picker.grep() end, desc = "[S]earch: [G]rep" },
			{ "<leader>s/", function() Snacks.picker.lines() end, desc = "[S]earch: Buffer Lines" },
			{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "[S]earch: [W]ord", mode = { "n", "x" } },

			-- Git
			{
				"<leader>gd",
				function()
					local dir = vim.fn.shellescape(vim.fn.expand("%:p:h"))
					vim.fn.system("git -C " .. dir .. " rev-parse --verify --quiet main")
					local base = vim.v.shell_error == 0 and "main" or "master"
					Snacks.picker.git_diff({ base = base })
				end,
				desc = "[G]it: [D]iff vs base branch",
			},
			{ "<leader>gh", function() Snacks.picker.git_log_file() end, desc = "[G]it: File [H]istory" },
			{ "<leader>sb", function() Snacks.picker.git_branches() end, desc = "[S]earch: Git [B]ranches" },
			{ "<leader>ghc", function() Snacks.picker.git_log() end, desc = "[G]it: Commit [H]istory" },
			{ "<leader>gbc", function() Snacks.picker.git_log_file() end, desc = "[G]it: [B]uffer [C]ommits" },

			-- Diagnostics & Undo
			{ "<leader>sx", function() Snacks.picker.diagnostics() end, desc = "[S]earch: Diagnostics" },
			{ "<leader>u", function() Snacks.picker.undo() end, desc = "[U]ndo History" },

			-- Notifications
			{ "<leader>sn", function() Snacks.picker.notifications() end, desc = "[S]earch: [N]otifications" },
		},
	},
}
