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
			-- "gitlab_ci_ls",
			"lua_ls",
			"ts_ls",
			"eslint",
			-- "prettier",
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
			})

			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>cgd", vim.lsp.buf.definition, { desc = "[C]ode: [G]o to [D]efinition" })
			vim.keymap.set("n", "<leader>cgr", vim.lsp.buf.references, { desc = "[C]ode: [G]o to [R]eference" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode: [A]ction" })
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode: [R]ename" })
		end,
	},
}
