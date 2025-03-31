return {
	{
		"williamboman/mason.nvim",
		event = "BufRead", -- Wait until a buffer is loaded
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local all_servers = {
				"lua_ls",
				"prosemd_lsp",
				"eslint",
				"cssls",
				"ts_ls",
				"ember",
				"texlab",
				"pyright",
				"eslint",
				"cmake",
				"emmet_language_server",
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
