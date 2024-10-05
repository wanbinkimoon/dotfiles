return {
  "neovim/nvim-lspconfig",
  lazy = false,
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local lspconfig = require("lspconfig")

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
    })

    lspconfig.html.setup({
      capabilities = capabilities,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
    })

    lspconfig.yamlls.setup({
      capabilities = capabilities,
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
    })

    lspconfig.cssls.setup({
      capabilities = capabilities,
    })

    lspconfig.eslint.setup({
      --- ...
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })

    vim.keymap.set("n", "<leader>D", vim.lsp.buf.hover, { desc = "Definition" })
    vim.keymap.set("n", "<leader>cgd", vim.lsp.buf.definition, { desc = "[C]ode: [G]o to [D]efinition" })
    vim.keymap.set("n", "<leader>cgr", vim.lsp.buf.references, { desc = "[C]ode: [G]o to [R]eference" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode: [A]ction" })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode: [R]ename" })
  end,
}
