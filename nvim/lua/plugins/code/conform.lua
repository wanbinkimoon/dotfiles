return {
	"stevearc/conform.nvim",
	event = "BufWritePre", -- Load only when needed for saving
	opts = {
		formatters_by_ft = {
			javascript = { "oxfmt" },
			typescript = { "oxfmt" },
			javascriptreact = { "oxfmt" },
			typescriptreact = { "oxfmt" },
			json = { "oxfmt" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			svg = { "prettierd" },
			handlebars = { "prettierd" },
			markdown = { "prettierd" },
			lua = { "stylua" },
		},

		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_fallback = false }
		end,

		formatters = {
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

	config = function(_, opts)
		require("conform").setup(opts)

		vim.api.nvim_create_user_command("Format", function()
			require("conform").format({ async = true, lsp_fallback = false })
		end, {})

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, { desc = "Disable autoformat-on-save", bang = true })

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, { desc = "Re-enable autoformat-on-save" })
	end,
}
