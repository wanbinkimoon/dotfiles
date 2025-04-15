---@type vim.lsp.Config
return {
	cmd = { "ember-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "ember-cli-build.json" },
}
