-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function()
		local icons = require("config.icons")
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

		local width = math.floor(vim.o.columns * 0.8)
		local height = math.floor(vim.o.lines * 0.3)

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = width,
			max_height = height,
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focusable = true,
			relative = "cursor",
			max_width = width,
			max_height = height,
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
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Definition" })
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode: [A]ction" })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode: [R]ename" })
	end,
})

-- This is copied straight from blink
-- https://cmp.saghen.dev/installation#merging-lsp-capabilities
local capabilities = {
	textDocument = {
		foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		},
	},
}

capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

-- Setup default language server configuration
vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git", ".luarc.json", "package.json" },
})

-- Enable each language server by filename under the lsp/ folder
-- Make sure each file in lsp/ returns a table with the proper configuration
vim.lsp.enable({
	"css_ls",
	"eslint_ls",
	"eslint_d_ls",
	"emmet_ls",
	"ember_ls",
	"graphql_ls",
	"html_ls",
	"json_ls",
	"lua_ls",
	"python_ls",
	"ts_ls",
	"yaml_ls",
})
