---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".git", "package.json" },
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      validate = true,
    },
  },
}
