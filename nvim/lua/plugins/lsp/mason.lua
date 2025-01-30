return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		event = "BufRead",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local all_servers = {
				-- "jsonls",
				"lua_ls",
				-- "clangd",
				"prosemd_lsp",
				"eslint",
				"cssls",
				-- "vuels",
				-- "tsserver",
				"ts_ls",
				"ember",
				"texlab",
				-- "angularls",
				"eslint",
				"cmake",
				"emmet_language_server",
				-- "rust_analyzer",
				"tailwindcss",
			}

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = all_servers, -- will be installed by mason
				automatic_installation = false,
			})
		end,
	},
}
