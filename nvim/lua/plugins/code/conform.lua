return {
	"stevearc/conform.nvim",
	event = "BufWritePre", -- Load only when needed for saving
	opts = {
		formatters_by_ft = {
			javascript = { "eslint_d", "oxfmt", stop_after_first = true },
			typescript = { "eslint_d", "oxfmt", stop_after_first = true },
			javascriptreact = { "eslint_d", "oxfmt", stop_after_first = true },
			typescriptreact = { "eslint_d", "oxfmt", stop_after_first = true },
			json = { "oxfmt" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			svg = { "prettierd" },
			handlebars = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
		},

		format_on_save = {
			timeout_ms = 3000,
			lsp_fallback = false,
		},

		formatters = {
			eslint_d = {
				command = "eslint_d",
				args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
				stdin = true,
			},

			oxfmt = {
				command = "oxfmt",
				args = { "--stdin-filepath", "$FILENAME" },
				stdin = true,
			},

			prettierd = {
				command = "prettierd",
				args = { "$FILENAME" },
			},
		},
	},

	-- Simple Format command
	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_user_command("Format", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end, {})
	end,
}
