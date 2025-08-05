---@type vim.lsp.Config
return {
	cmd = { "node", "/Users/nicola.bertelloni/.local/share/fnm/node-versions/v22.18.0/installation/lib/node_modules/@emberwatch/ember-language-server/lib/start-server.js", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", "ember-cli-build.json" },
}
