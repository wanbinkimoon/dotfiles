---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
  root_markers = { ".git", "package.json" },
}
