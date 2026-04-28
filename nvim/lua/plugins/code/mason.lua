return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Language servers
					"eslint-lsp",
					"typescript-language-server",
					"lua-language-server",
					"json-lsp",
					"yaml-language-server",
					"html-lsp",
					"css-lsp",
					"emmet-language-server",
					"marksman",
					"graphql-language-service-cli",
					"pyright",
					-- Formatters
					"oxfmt",
					"prettierd",
					"stylua",
					-- Linters
					"djlint",
				},
				auto_update = false,
				run_on_start = true,
				start_delay = 3000, -- ms: defer past startup-critical path
			})
		end,
	},
}
