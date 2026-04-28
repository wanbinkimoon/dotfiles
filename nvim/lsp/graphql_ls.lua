---@type vim.lsp.Config
return {
  cmd = { "graphql-lsp", "server", "--method", "stream" },
  filetypes = { "gql", "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
}
