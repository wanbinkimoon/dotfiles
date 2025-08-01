local eslint_filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"vue",
	"svelte",
}
return {
	"neovim/nvim-lspconfig",
	event = "LspAttach",
	enabled = true,
	opts = { inlay_hints = { enabled = true } },
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		lspconfig.eslint.setup({
			capabilities = capabilities,
			filetypes = eslint_filetypes,
			settings = {
				workingDirectories = { mode = "auto" },
			},
			on_attach = function(client)
				client.server_capabilities.document_formatting = true
				vim.api.nvim_create_autocmd("BufWritePre", {
					callback = function()
						-- List of file types where ESLint should be applied

						-- Get current file type
						local file_type = vim.bo.filetype

						-- Check file size (skip for very large files)
						local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
						local max_file_size = 1024 * 1024 -- 1MB

						-- Apply ESLint for specific file types and small files
						if
							vim.tbl_contains(eslint_filetypes, file_type)
							and file_size > 0
							and file_size < max_file_size
						then
							vim.cmd("EslintFixAll")
						end

						-- Format all file types
						vim.cmd("Format")
					end,
				})
			end,
		})

		lspconfig.ember.setup({
			capabilities = capabilities,
			on_attach = function(client)
				client.server_capabilities.document_formatting = true
				vim.api.nvim_create_autocmd("BufWritePre", {
					callback = function()
						vim.cmd("Format")
					end,
				})
			end,
		})
	end,
}
