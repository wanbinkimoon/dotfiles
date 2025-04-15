---@type vim.lsp.Config
return {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { ".git", "package.json" },
  settings = {
    html = {
      format = {
        -- Use prettier for formatting
        formatter = "prettier",
        -- Format on save
        formatOnSave = true,
      },
      suggest = {
        html5 = true,
      },
    },
  },
}
