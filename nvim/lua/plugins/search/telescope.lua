return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- Load only when you run :Telescope
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{ "nvim-telescope/telescope-ui-select.nvim", lazy = true },
			{ "nvim-telescope/telescope-live-grep-args.nvim", lazy = true },
			{ "ahmedkhalf/project.nvim", lazy = true },
			{ "echasnovski/mini.icons", lazy = true },
			{ "mrloop/telescope-git-branch.nvim", lazy = true },
			{ "isak102/telescope-git-file-history.nvim", lazy = true },
			{ "nvim-lua/plenary.nvim", "tpope/vim-fugitive", lazy = true },
			{
				{
					"LukasPietzschmann/telescope-tabs",
					config = function()
						require("telescope").load_extension("telescope-tabs")
						require("telescope-tabs").setup({
							-- Your custom config :^)
							vim.api.nvim_set_keymap(
								"n",
								"<leader>st",
								":lua require('telescope-tabs').list_tabs()<CR>",
								{ noremap = true }
							),
						})
					end,
					dependencies = { "nvim-telescope/telescope.nvim" },
				},
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")

			-- Core configuration components
			local dimensions = { width = 0.85, height = 0.85 }

			-- Layout configuration
			local layout = {
				horizontal = {
					height = dimensions.height,
					width = dimensions.width,
					preview_width = 0.5,
					prompt_position = "top",
					preview_position = "bottom",
				},
			}

			-- Common mappings
			local common_mappings = {
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
			}

			-- Visual styling
			local visual_style = {
				borderchars = {
					prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				highlights = {
					selection_caret = { fg = "#89b4fa" },
					selection = { bg = "#45475a", fg = "#89b4fa" },
				},
			}

			local options = {
				defaults = {
					layout_strategy = "horizontal",
					layout_config = layout,
					sorting_strategy = "ascending",
					results_title = false,
					prompt_prefix = "   ",
					selection_caret = "  ",
					initial_mode = "insert",
					previewer = false,
					preview = { hide_on_startup = true },
					mappings = common_mappings,
					borderchars = visual_style.borderchars,
					highlights = visual_style.highlights,
				},
			}
			-- Common picker configuration template
			local picker_template = {
				previewer = false,
				layout_config = {
					width = dimensions.width,
					height = dimensions.height,
				},
			}

			-- File picker configurations
			local file_pickers = {
				find_files = vim.tbl_extend("force", picker_template, {}),
				oldfiles = vim.tbl_extend("force", picker_template, {
					initial_mode = "normal",
				}),
				buffers = vim.tbl_extend("force", picker_template, {
					initial_mode = "normal",
				}),
			}

			-- Git picker configurations
			local git_pickers = {
				git_branches = vim.tbl_extend("force", picker_template, {}),
				git_commits = vim.tbl_extend("force", picker_template, {
					initial_mode = "normal",
				}),
				git_bcommits = vim.tbl_extend("force", picker_template, {
					initial_mode = "normal",
				}),
				git_file_history = vim.tbl_extend("force", picker_template, {
					initial_mode = "normal",
					layout_strategy = "vertical",
				}),
			}

			-- Search picker configurations
			local search_pickers = {
				live_grep = vim.tbl_extend("force", picker_template, {
					additional_args = function()
						return { "--hidden", "--glob=!**/.git/*" }
					end,
					file_ignore_patterns = { "node_modules/", ".git/" },
				}),
			}

			options.pickers = vim.tbl_extend("force", {}, file_pickers, git_pickers, search_pickers)

			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						layout_config = {
							width = dimensions.width,
							height = dimensions.height,
						},
					}),
				},
				["live_grep_args"] = {
					auto_quoting = true,
					previewer = false,
					layout_config = {
						width = dimensions.width,
						height = dimensions.height,
					},
					mappings = {
						i = {
							["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
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
			}

			vim.api.nvim_create_user_command("GrepCurrentDir", function()
				require("telescope.builtin").live_grep({
					search_dirs = { vim.fn.expand("%:p:h") },
					prompt_title = "Grep in: " .. vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~:."),
				})
			end, {})

			vim.api.nvim_create_user_command("GrepProject", function()
				local ok, project_root = pcall(require("project_nvim.project").get_project_root)
				if not ok or not project_root then
					project_root = vim.loop.cwd()
				end

				require("telescope.builtin").live_grep({
					cwd = project_root,
					prompt_title = "Grep in Project: " .. vim.fn.fnamemodify(project_root, ":~:."),
				})
			end, {})

			vim.api.nvim_create_user_command("FindFilesInDir", function(opts)
				require("telescope.builtin").find_files({
					search_dirs = { opts.args },
					prompt_title = "Files in: " .. vim.fn.fnamemodify(opts.args, ":~:."),
				})
			end, { nargs = 1 })

			-- Enhance existing functionality with these tricks:
			-- 1. In live grep prompt:
			--    - Type `:dir<space>` to search specific directories
			--    - Type `:filetype<space>` to filter by file type
			-- 2. Use these commands from normal mode:
			--    - :GrepCurrentDir
			--    - :GrepProject
			--    - :FindFilesInDir [path]

			-- Optional: Add to which-key descriptions if you use it

			telescope.setup(options)

			-- Your existing keymaps
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>s<CR>", ":GrepCurrentDir<CR>", { desc = "Grep Current Dir" })
			vim.keymap.set("n", "<leader>sp", ":GrepProject<CR>", { desc = "Grep Project" })

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

			-- Load extensions
			telescope.load_extension("ui-select")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("git_branch")
			telescope.load_extension("git_file_history")

			-- Set up keymaps by category
			-- File search
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch: [F]iles" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "[S]earch: Recent Files" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch: [B]uffers" })

			-- Text search
			vim.keymap.set("n", "<leader>s<CR>", ":GrepCurrentDir<CR>", { desc = "Grep Current Dir" })
			vim.keymap.set("n", "<leader>sp", ":GrepProject<CR>", { desc = "Grep Project" })
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
				{ desc = "[S]earch current [S]election" }
			)

			local nvmode = { "n", "v" }
			-- Git operations
			vim.keymap.set(nvmode, "<leader>sd", git_branch.files, { desc = "[S]earch: Git [D]iff" })
			vim.keymap.set(nvmode, "<leader>sb", builtin.git_branches, { desc = "[S]earch: Git [B]ranches" })
			vim.keymap.set(nvmode, "<leader>sc", builtin.git_commits, { desc = "[S]earch: Git [C]ommits" })
			vim.keymap.set(nvmode, "<leader>sh", builtin.git_bcommits, { desc = "[S]earch: Git [H]istory" })
			vim.keymap.set(
				nvmode,
				"<leader>sH",
				":Telescope git_file_history<CR>",
				{ desc = "[S]earch: Git [H]istory" }
			)

			-- LSP operations
			vim.keymap.set(nvmode, "gd", builtin.lsp_definitions, { desc = "Search: LSP [D]efinitions", remap = true })
			vim.keymap.set(nvmode, "gr", builtin.lsp_references, { desc = "Search: LSP [R]eferences" })
			vim.keymap.set(nvmode, "gi", builtin.lsp_implementations, { desc = "Search: LSP [I]mplementations" })
			vim.keymap.set(nvmode, "gt", builtin.lsp_type_definitions, { desc = "Search: LSP [T]ype" })
			vim.keymap.set(nvmode, "gs", builtin.lsp_document_symbols, { desc = "Search: LSP [S]ymbols" })
		end,
	},
}
