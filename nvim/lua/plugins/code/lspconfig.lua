return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
	dependencies = {},
	config = function()
		local lspconfig = require("lspconfig")

		lspconfig.eslint.setup({
			root_dir = function(fname)
				local workspace_root =
					lspconfig.util.root_pattern("pnpm-workspace.yaml", "yarn.lock", "lerna.json")(fname)
				if workspace_root then
					return workspace_root
				end
				-- Fallback to git root
				return lspconfig.util.root_pattern(".git")(fname) or lspconfig.util.root_pattern("package.json")(fname)
			end,
			settings = {
				validate = "on",
				packageManager = "pnpm",
				useESLintClass = false,
				experimental = {
					useFlatConfig = false,
				},
				format = false, -- Let conform handle formatting
				quiet = false, -- Show errors to help debug @repo resolution
				onIgnoredFiles = "off",
				run = "onType",
				workingDirectories = { mode = "auto" },
				options = {
					extensions = { ".js", ".jsx", ".ts", ".tsx" },
				},
			},
		})

		-- Setup TypeScript LSP
		lspconfig.ts_ls.setup({
			on_attach = function(client)
				-- Disable typescript's formatting in favor of prettier/eslint
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false
			end,
		})
	end,
}
