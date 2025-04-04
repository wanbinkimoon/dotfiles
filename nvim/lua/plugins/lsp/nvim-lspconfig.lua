return {
	"neovim/nvim-lspconfig",
	event = "LspAttach",
	opts = {
		inlay_hints = { enabled = true },
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local lspconfig = require("lspconfig")
		local icons = require("config.icons")

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

		lspconfig.pyright.setup({
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						-- Enable more detailed analysis
						diagnosticSeverityOverrides = {
							reportGeneralTypeIssues = "warning",
							reportOptionalMemberAccess = "warning",
							reportOptionalCall = "warning",
							reportOptionalIterable = "warning",
							reportOptionalContextManager = "warning",
							reportOptionalOperand = "warning",
						},
					},
				},
			},
		})
		lspconfig.graphql.setup({
			capabilities = capabilities,
			filetypes = {
				"gql",
				"graphql",
				"javascriptreact",
				"typescriptreact",
			},
		})

		lspconfig.emmet_ls.setup({
			capabilities = capabilities,
			filetypes = {
				"css",
				"html",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"typescriptreact",
			},
		})

		lspconfig.eslint.setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.document_formatting = true
				vim.api.nvim_create_autocmd("BufWritePre", {
					callback = function()
						-- List of file types where ESLint should be applied
						local eslint_filetypes = {
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"vue",
							"svelte",
						}

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

		-- Basic Setup START --
		local signs = {
			{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
			{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
			{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
			{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
		}
		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
		end

		vim.diagnostic.config({
			-- disable virtual text
			virtual_text = { prefix = icons.ui.VirtualPrefix },
			-- show signs
			signs = { active = signs },
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "single",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "single",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "single",
			focusable = true,
			relative = "cursor",
		})

		-- suppress error messages from lang servers
		---@diagnostic disable-next-line: duplicate-set-field
		vim.notify = function(msg, log_level)
			if msg:match("exit code") then
				return
			end
			if log_level == vim.log.levels.ERROR then
				vim.api.nvim_err_writeln(msg)
			else
				vim.api.nvim_echo({ { msg } }, true, {})
			end
		end

		-- Borders for LspInfo winodw
		local win = require("lspconfig.ui.windows")
		local _default_opts = win.default_opts

		win.default_opts = function(options)
			local opts = _default_opts(options)
			opts.border = "single"
			return opts
		end
		-- Basic Setup END --

		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Definition" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[C]ode: Go to [d]efinition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[C]ode: Go to [R]eference" })
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "[C]ode: Go to [i]mplementation" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode: [A]ction" })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode: [R]ename" })
	end,
}
