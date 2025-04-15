---@type vim.lsp.Config
return {
  cmd = { "emmet-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "less",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
  },
  init_options = {
    html = {
      options = {
        ["bem.enabled"] = true,
        ["jsx.enabled"] = true,
        ["jsx.selfClosingStyle"] = "html",
        ["jsx.suppressSelfClosingStyleWarning"] = true,
        ["html.format.enable"] = false,
        ["html.format.wrapAttributes"] = "force",
        ["html.format.wrapAttributesIndentSize"] = 2,
      },
    },
  },
}
