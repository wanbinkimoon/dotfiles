return {
	"folke/noice.nvim",
	enabled = true,
	event = { "CmdlineEnter" },
	dependencies = {
		"MunifTanjim/nui.nvim",
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
		-- Define noice configuration options
		local noice_opts = {
			-- Command line configuration
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {
					position = { row = "10%", col = "50%" },
					size = { width = "50%" },
					border = { style = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
				},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = {
						pattern = {
							"^:%s*lua%s+",
							"^:%s*lua%s*=%s*",
							"^:%s*=%s*",
						},
						icon = "",
						lang = "lua",
					},
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = { view = "cmdline_input", icon = "󰥻 " },
				},
			},

			-- Disabled features
			popupmenu = { enabled = false },
			notify = { enabled = false },
			messages = { enabled = false },
			routes = { enabled = false },
			documentation = { enabled = false },

			-- LSP configuration
			lsp = {
				enabled = true,
				-- hover = { enabled = false },
				-- signature = { enabled = false },
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false,
				},
			},

			-- Presets configuration
			presets = {
				bottom_search = false,
				command_palette = false,
				long_message_to_split = false,
				inc_rename = false,
				lsp_doc_border = false,
			},
		}

		-- Apply configuration
		require("noice").setup(noice_opts)
	end,
}
