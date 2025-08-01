return {
	"stevearc/conform.nvim",
	event = "BufWritePre", -- Load only when needed for saving
	opts = {
		formatters_by_ft = {
			-- For JS/TS files, run eslint_d first, then prettierd
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },

			-- For other web files, just use prettierd
			json = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			svg = { "prettierd" },
			-- handlebars = { "djlint" },

			-- For Lua files
			lua = { "stylua" },
		},

		-- Simple format on save configuration
		format_on_save = {
			timeout_ms = 3000,
			lsp_fallback = true,
		},

		-- Basic formatter configurations
		formatters = {
			eslint_d = {
				command = "eslint_d",
				args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
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
