return {
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		cmd = "Telescope",
		-- event = "UIEnter",
		keys = {
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch: [F]iles" },
			{ "<leader><leader>", "<cmd>Telescope oldfiles<cr>", desc = "[S]earch: Recent Files" },
			{ "<leader>sg", "<cmd>Telescope live_grep_args<cr>", desc = "[S]earch: Live [G]rep" },
			{ "<leader>s/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch: Live [G]rep" },
		},
		dependencies = {
			"tpope/vim-fugitive",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"mrloop/telescope-git-branch.nvim",
			"isak102/telescope-git-file-history.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local dimensions = { width = 0.75, height = 0.75 }

			-- Custom live_grep filter state (persists within session)
			local live_grep_filters = {
				extension = nil, ---@type nil|string
				directories = nil, ---@type nil|string[]
			}

			local function get_directories()
				if vim.fn.executable("fd") ~= 1 then
					vim.notify("fd not found — folder picker unavailable", vim.log.levels.WARN)
					return nil
				end
				local data = {}
				local handle = io.popen("fd --type d --hidden --exclude .git -X ls -h -d", "r")
				if not handle then
					return {}
				end
				local result = handle:read("*a")
				handle:close()
				for entry in result:gmatch("[^\r\n]+") do
					table.insert(data, entry .. "/")
				end
				table.insert(data, 1, "./")
				return data
			end

			local function run_live_grep(current_input)
				require("telescope").extensions.live_grep_args.live_grep_args({
					additional_args = live_grep_filters.extension and function()
						return { "-g", "*." .. live_grep_filters.extension }
					end or nil,
					search_dirs = live_grep_filters.directories,
					default_text = current_input,
					previewer = false,
					layout_config = dimensions,
				})
			end

			local action_state = require("telescope.actions.state")
			local action_set = require("telescope.actions.set")
			local finders = require("telescope.finders")
			local make_entry = require("telescope.make_entry")
			local conf = require("telescope.config").values
			local pickers_mod = require("telescope.pickers")

			local function set_extension(prompt_bufnr)
				local current_input = action_state.get_current_line()
				vim.ui.input({ prompt = "*." }, function(input)
					if input == nil then
						return
					end
					input = input:gsub("^%.", "")
					live_grep_filters.extension = input ~= "" and input or nil
					actions.close(prompt_bufnr)
					run_live_grep(current_input)
				end)
			end

			local function set_folders(prompt_bufnr)
				local current_input = action_state.get_current_line()
				local data = get_directories()
				if data == nil then
					return -- get_directories already notified
				end
				if vim.tbl_isempty(data) then
					vim.notify("No directories found", vim.log.levels.WARN)
					return
				end
				actions.close(prompt_bufnr)
				pickers_mod
					.new({}, {
						prompt_title = "Folders for Live Grep",
						finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file({}) }),
						previewer = conf.file_previewer({}),
						sorter = conf.file_sorter({}),
						attach_mappings = function(bufnr)
							action_set.select:replace(function()
								local current_picker = action_state.get_current_picker(bufnr)
								local dirs = {}
								local selections = current_picker:get_multi_selection()
								if vim.tbl_isempty(selections) then
									table.insert(dirs, action_state.get_selected_entry().value)
								else
									for _, selection in ipairs(selections) do
										table.insert(dirs, selection.value)
									end
								end
								live_grep_filters.directories = dirs
								actions.close(bufnr)
								run_live_grep(current_input)
							end)
							return true
						end,
					})
					:find()
			end

			local picker_defaults = { previewer = false, layout_config = dimensions, hidden = true }

			-- Core configuration with minimal styling
			local config = {
				defaults = {
					layout_strategy = "vertical",
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
					file_ignore_patterns = { "node_modules/", ".git/" },
					use_ft_detect = false,
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
							-- Change history navigation keys (insert mode)
							["<M-Up>"] = require("telescope.actions").cycle_history_prev,
							["<M-Down>"] = require("telescope.actions").cycle_history_next,
						},
						i = {
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
							["<C-c>"] = actions.close,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							-- Change history navigation keys (insert mode)
							["<M-Up>"] = require("telescope.actions").cycle_history_prev,
							["<M-Down>"] = require("telescope.actions").cycle_history_next,
						},
					},
				},

				-- Simplified pickers with common settings
				pickers = {
					find_files = picker_defaults,
					oldfiles = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_branches = picker_defaults,
					git_commits = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_bcommits = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
					git_file_history = vim.tbl_extend("force", picker_defaults, { initial_mode = "normal" }),
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
								["<C-f>"] = set_extension,
								["<C-l>"] = set_folders,
							},
						},
					},
				},
			}

			telescope.setup(config)

			-- Load all extensions at once
			for _, ext in ipairs({
				"ui-select",
				"live_grep_args",
				"git_branch",
				"git_file_history",
			}) do
				telescope.load_extension(ext)
			end

			-- Setup custom commands and keymaps
			local builtin = require("telescope.builtin")

			-- Map function
			local map = function(mode, lhs, rhs, desc, opts)
				vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {}))
			end

			-- File and text search keymaps
			map("n", "<leader>sf", builtin.find_files, "[S]earch: [F]iles")
			map("n", "<leader><leader>", builtin.oldfiles, "[S]earch: Recent Files")
			map("n", "<leader>s/", builtin.current_buffer_fuzzy_find, "[S]earch: Live [G]rep")
			map("n", "<leader>sg", "<cmd> Telescope live_grep_args<cr>", "[S]earch: Live [G]rep")

			local lga = require("telescope-live-grep-args.shortcuts")
			map({ "n", "v" }, "<leader>sw", lga.grep_word_under_cursor, "[S]earch: [W]ord")
			map("v", "<leader>ss", lga.grep_visual_selection, "[S]earch: Current [S]election")

			-- Git keymaps
			map({ "n", "v" }, "<leader>sd", require("git_branch").files, "[S]earch: Git [D]iff")
			map({ "n", "v" }, "<leader>gh", "<cmd>Telescope git_file_history<cr>", "[G]it: File [H]istory")
			map({ "n", "v" }, "<leader>sb", builtin.git_branches, "[S]earch: Git [B]ranches")
			map({ "n", "v" }, "<leader>ghc", builtin.git_commits, "[G]it: Commit [H]istory")
			map({ "n", "v" }, "<leader>gbc", builtin.git_bcommits, "[G]it: [B]uffer [C]ommits")

			-- Notification history command
			vim.api.nvim_create_user_command("NotificationHistory", function()
				if telescope.extensions.notify then
					telescope.extensions.notify.notify()
				else
					vim.notify("Notify extension not loaded", vim.log.levels.WARN)
				end
			end, { desc = "Open notification history in Telescope" })
		end,
	},
}
