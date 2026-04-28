local icons = require("config.icons")

-- Diagnostic configuration (global, no LSP dependency)
vim.diagnostic.config({
	virtual_text = { prefix = icons.ui.VirtualPrefix },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
		},
	},
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

-- Default LSP server configuration (no plugin dependencies)
vim.lsp.config("*", {
	root_markers = { ".git", ".luarc.json", "package.json" },
	inlay_hints = { enabled = true },
})

-- Buffer-local setup on LSP attach
local capabilities_configured = false
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function()
		-- Merge blink.cmp capabilities once (available after lazy.nvim setup)
		if not capabilities_configured then
			local capabilities = require("blink.cmp").get_lsp_capabilities({
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			})
			vim.lsp.config("*", { capabilities = capabilities })
			capabilities_configured = true
		end

		-- Override gd to use LSP (default gd is text-search only, same-file)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to [D]efinition" })

		-- Override grr default to use Trouble instead of quickfix
		vim.keymap.set("n", "grr", "<cmd>Trouble lsp_references<cr>", { desc = "LSP: [R]eferences (Trouble)" })

		vim.keymap.set("n", "grh", function()
			vim.cmd("split")
			vim.lsp.buf.definition()
		end, { desc = "LSP: Def in [H]orizontal Split" })
		vim.keymap.set("n", "grv", function()
			vim.cmd("vsplit")
			vim.lsp.buf.definition()
		end, { desc = "LSP: Def in [V]ertical Split" })

		-- Manual ESLint fix-all (replaces eslint_d --fix-to-stdout that ran on save before)
		vim.keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
				apply = true,
			})
		end, { desc = "LSP: ESLint Fix All (manual)" })
		vim.api.nvim_buf_create_user_command(0, "EslintFixAll", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.fixAll.eslint" }, diagnostics = {} },
				apply = true,
			})
		end, { desc = "Run ESLint source.fixAll on current buffer" })
	end,
})

vim.lsp.enable({
	"css_ls",
	"eslint_ls",
	"emmet_ls",
	"ember_ls",
	-- "glint_ls",
	"graphql_ls",
	"html_ls",
	"json_ls",
	"lua_ls",
	"marksman",
	"python_ls",
	"ts_ls",
	"yaml_ls",
})
