-- luacheck: globals vim
return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"ahmedkhalf/project.nvim",
			"echasnovski/mini.icons",
			"mrloop/telescope-git-branch.nvim",
			"isak102/telescope-git-file-history.nvim",
			"tpope/vim-fugitive",
			"LukasPietzschmann/telescope-tabs",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local dimensions = { width = 0.75, height = 0.75 }
			local picker_defaults = { previewer = false, layout_config = dimensions }

			-- Core configuration with minimal styling
			local config = {
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							height = dimensions.height,
							width = dimensions.width,
							preview_width = 0.5,
							prompt_position = "top",
							preview_position = "bottom",
						},
					},
					sorting_strategy = "ascending",
					results_title = false,
					prompt_prefix = "   ",
					selection_caret = "  ",
					initial_mode = "insert",
					previewer = false,
					preview = { hide_on_startup = true },
					borderchars = {
						prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					},
					highlights = {
						selection_caret = { fg = "#89b4fa" },
						selection = { bg = "#45475a", fg = "#89b4fa" },
					},
					mappings = {
						n = {
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
							["j"] = actions.move_selection_next,
							["k"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<CR>"] = actions.select_default,
						},
						i = {
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
							["<C-c>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},

				-- Simplified pickers with common settings
				pickers = {
					find_files = picker_defaults,
					oldfiles = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					buffers = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_branches = picker_defaults,
					git_commits = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_bcommits = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_file_history = vim.tbl_extend("force", picker_defaults, {
						initial_mode = "normal",
						layout_strategy = "vertical",
					}),
					live_grep = vim.tbl_extend("force", picker_defaults, {
						additional_args = function()
							return { "--hidden", "--glob=!**/.git/*", "--max-count=1000" }
						end,
						file_ignore_patterns = { "node_modules/", ".git/", "dist/", "build/", ".next/", "*.min.js" },
					}),
				},

				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown({ layout_config = dimensions }) },
					["live_grep_args"] = {
						auto_quoting = true,
						previewer = false,
						layout_config = dimensions,
						mappings = {
							i = {
								["<C-g>"] = require("telescope-live-grep-args.actions").quote_prompt({
									postfix = " --iglob ",
								}),
								["<C-e>"] = function(prompt_bufnr)
									local dir = vim.fn.input("Search directory: ", "", "dir")
									actions._close(prompt_bufnr, true)
									require("telescope.builtin").live_grep({
										search_dirs = { dir },
										prompt_title = "Grep in: " .. vim.fn.fnamemodify(dir, ":~:."),
									})
								end,
							},
						},
					},
				},
			}

			telescope.setup(config)

			-- Load all extensions at once
			for _, ext in ipairs({ "ui-select", "live_grep_args", "git_branch", "git_file_history", "telescope-tabs" }) do
				telescope.load_extension(ext)
			end
			require("telescope-tabs").setup({})

			-- Setup custom commands and keymaps
			local builtin = require("telescope.builtin")

			-- Custom commands
			vim.api.nvim_create_user_command("GrepCurrentDir", function()
				local dir = vim.fn.expand("%:p:h")
				builtin.live_grep({
					search_dirs = { dir },
					prompt_title = "Grep in: " .. vim.fn.fnamemodify(dir, ":~:."),
				})
			end, {})

			vim.api.nvim_create_user_command("GrepProject", function()
				local ok, root = pcall(require("project_nvim.project").get_project_root)
				local dir = ok and root or vim.loop.cwd()
				builtin.live_grep({
					cwd = dir,
					prompt_title = "Grep in Project: " .. vim.fn.fnamemodify(dir, ":~:."),
				})
			end, {})

			vim.api.nvim_create_user_command("FindFilesInDir", function(opts)
				builtin.find_files({
					search_dirs = { opts.args },
					prompt_title = "Files in: " .. vim.fn.fnamemodify(opts.args, ":~:."),
				})
			end, { nargs = 1 })

			-- Map function
			local map = function(mode, lhs, rhs, desc, opts)
				vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {}))
			end

			-- File and text search keymaps
			map("n", "<leader>sf", builtin.find_files, "[S]earch: [F]iles")
			map("n", "<leader><leader>", builtin.oldfiles, "[S]earch: Recent Files")
			map("n", "<leader>sg", "<cmd> Telescope live_grep_args<cr>", "[S]earch: Live [G]rep")
			map("n", "<leader>s/", builtin.current_buffer_fuzzy_find, "[S]earch: Live [G]rep")

			local lga = require("telescope-live-grep-args.shortcuts")
			map({ "n", "v" }, "<leader>sw", lga.grep_word_under_cursor, "[S]earch: [W]ord")
			map("v", "<leader>ss", lga.grep_visual_selection, "[S]earch: Current [S]election")

			-- Git keymaps
			map({ "n", "v" }, "<leader>sd", require("git_branch").files, "[S]earch: Git [D]iff")
			map({ "n", "v" }, "<leader>sb", builtin.git_branches, "[S]earch: Git [B]ranches")
			map({ "n", "v" }, "<leader>gc", builtin.git_commits, "[G]it: [C]ommits")
			map({ "n", "v" }, "<leader>gcb", builtin.git_bcommits, "[G]it: [H]istory")
			map({ "n", "v" }, "<leader>gh", "<cmd>Telescope git_file_history<cr>", "[G]it: File [H]istory")

			-- LSP keymaps
			map({ "n", "v" }, "Gd", builtin.lsp_definitions, "LSP: [D]efinitions", { remap = true })
			map({ "n", "v" }, "Gr", builtin.lsp_references, "LSP: [R]eferences")
			map({ "n", "v" }, "Gt", builtin.lsp_type_definitions, "LSP: [T]ype Definitions")
		end,
	},
}
