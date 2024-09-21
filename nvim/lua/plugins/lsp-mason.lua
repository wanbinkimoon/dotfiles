return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
		ensure_installed = {
			"html",
			"jsonls",
			"lua_ls",
			"ts_ls",
			"eslint",
		},
	},
}
