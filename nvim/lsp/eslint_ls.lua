---@type vim.lsp.Config
return {
	{
		cmd = { "vscode-eslint-language-server", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { ".git", "package.json" },
	},
	{
		cmd = { "eslint_d", "--stdio" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
		root_markers = { ".git", "package.json" },
	},
}
