return {
	"folke/noice.nvim",
	enabled = true,
	event = {
		"CmdlineEnter",
	},
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					background_colour = "#000000",
				})
			end,
		},
	},
	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {
					position = {
						row = "10%",
						col = "50%",
					},
					size = {
						width = "50%",
					},
					border = {
						style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					},
				}, -- global options for the cmdline. See section on views
				---@type table<string, CmdlineFormat>
				format = {
					-- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
					-- view: (default is cmdline view)
					-- opts: any options passed to the view
					-- icon_hl_group: optional hl_group for the icon
					-- title: set to anything or empty string to hide
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
					-- lua = false, -- to disable a format, set to `false`
				},
			},
			popupmenu = {
				enabled = false,
				relative = "editor",
				position = {
					row = "8",
					col = "50%",
				},
			},
			notify = {
				enabled = false,
			},
			messages = {
				-- NOTE: If you enable messages, then the cmdline is enabled automatically.
				-- This is a current Neovim limitation.
				enabled = false, -- disable the Noice messages UI
				view = "virtualtext", -- default view for messages
				view_info = "virtualtext", -- view for info messages
				view_error = "virtualtext", -- view for errors
				view_warn = "virtualtext", -- view for warnings
				view_history = "messages", -- view for :messages
				view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			documentation = {
				enabled = false,
			},
			lsp = {
				enabled = false, -- disable all LSP features
				hover = {
					enabled = false,
				},
				signature = {
					enabled = false,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = false,
			},
		})
	end,
}
