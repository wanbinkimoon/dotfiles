return {
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{ "mrloop/telescope-git-branch.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local options = {
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							height = 0.85,
							width = 0.85,
							preview_width = 0.5,
							prompt_position = "top",
							preview_position = "bottom",
						},
					},
					sorting_strategy = "ascending",
					-- Center results in the screen
					results_title = false,
					prompt_prefix = "   ",
					selection_caret = "  ",
					-- Initial state: no preview, normal mode
					initial_mode = "insert",
					preview = {
						hide_on_startup = true,
					},
					mappings = {
						n = {
							["<localleader>p"] = require("telescope.actions.layout").toggle_preview,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<CR>"] = actions.select_default,
						},
						i = {
							["<localleader>p"] = require("telescope.actions.layout").toggle_preview,
							["<C-c>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
					-- Consistent theme across all pickers
					borderchars = {
						prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					},
					-- Better highlighting
					highlights = {
						selection_caret = { fg = "#89b4fa" },
						selection = { bg = "#45475a", fg = "#89b4fa" },
					},
				},

				pickers = {
					-- Consistent configuration for all pickers
					find_files = {
						-- theme = "dropdown",
						previewer = false,
						layout_config = {
							width = 0.65,
							height = 0.65,
						},
					},
					oldfiles = {
						-- theme = "dropdown",
						previewer = false,
						initial_mode = "normal",
						layout_config = {
							width = 0.65,
							height = 0.65,
						},
					},
					buffers = {
						-- theme = "dropdown",
						initial_mode = "normal",
						previewer = false,
						layout_config = {
							width = 0.65,
							height = 0.65,
						},
					},
					live_grep = {
						theme = "dropdown",
						previewer = false,
						layout_config = {
							width = 0.65,
							height = 0.65,
						},
					},
				},

				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							layout_config = {
								width = 0.65,
								height = 0.65,
							},
						}),
					},
					["live_grep_args"] = {
						auto_quoting = true,
						theme = "dropdown",
						previewer = false,
						layout_config = {
							width = 0.65,
							height = 0.65,
						},
					},
				},
			}

			telescope.setup(options)

			-- Your existing keymaps
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch: [F]iles" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "[S]earch: Oldfiles " })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch: [B]uffers" })

			local git_branch = require("git_branch")
			vim.keymap.set({ "n", "v" }, "<leader>sd", git_branch.files, { desc = "[S]earch: Git [D]iff" })

			local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
			vim.keymap.set(
				"n",
				"<leader>sg",
				":lua require('telescope').extensions.live_grep_args.live_grep_args({opts = { search_dirs = true }})<CR>",
				{ desc = "[S]earch: Live [G]rep" }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<leader>sw",
				live_grep_args_shortcuts.grep_word_under_cursor,
				{ desc = "[S]earch: [W]ord" }
			)
			vim.keymap.set(
				"v",
				"<leader>ss",
				live_grep_args_shortcuts.grep_visual_selection,
				{ noremap = true, silent = true, desc = "[S]earch current [S]election" }
			)

			-- LSP related keymaps
			vim.keymap.set(
				{ "n", "v" },
				"gd",
				builtin.lsp_definitions,
				{ desc = "Search: LSP [D]efinitions", remap = true }
			)
			vim.keymap.set({ "n", "v" }, "gr", builtin.lsp_references, { desc = "Search: LSP [R]eferences" })
			vim.keymap.set({ "n", "v" }, "gi", builtin.lsp_implementations, { desc = "search: lsp [i]mplementations" })
			vim.keymap.set(
				{ "n", "v" },
				"gt",
				builtin.lsp_type_definitions,
				{ desc = "Search: LSP [T]ype Definitions" }
			)
			vim.keymap.set({ "n", "v" }, "gs", builtin.lsp_document_symbols, { desc = "Search: LSP [S]ymbols" })

			telescope.load_extension("ui-select")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("git_branch")
		end,
	},
}
