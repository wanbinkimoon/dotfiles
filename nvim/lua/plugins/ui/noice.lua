return {
	"folke/noice.nvim",
	enabled = true,
	event = { "CmdlineEnter" },
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		-- Define noice configuration options
		local noice_opts = {
			-- Command line configuration
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {
					position = { row = "10%", col = "50%" },
					size = { width = "72.5%" },
				},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
					input = { view = "cmdline_input", icon = "󰥻 " },
				},
			},

			popupmenu = { enabled = false },
			notify = { enabled = false },
			messages = { enabled = false },
			routes = { enabled = false },
			documentation = { enabled = false },

			-- LSP configuration
			lsp = {
				enabled = true,
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = false,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = false,
				},
			},
		}

		-- Apply configuration
		require("noice").setup(noice_opts)
	end,
}
