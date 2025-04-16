---@type vim.lsp.Config
return {
	{
		cmd = { "eslint_d", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = {
			".eslintrc.js",
			".eslintrc.json",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc",
			"package.json",
		},
	},
}
