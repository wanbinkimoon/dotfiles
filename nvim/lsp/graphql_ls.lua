---@type vim.lsp.Config
return {
  cmd = { "graphql-lsp", "server", "--stdio" },
  filetypes = { "gql", "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
}
