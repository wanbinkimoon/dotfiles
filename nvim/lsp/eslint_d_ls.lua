---@type vim.lsp.Config
return {
	cmd = { "eslint_d", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_markers = {
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
		"package.json",
	},
	settings = {
		validate = "on",
		packageManager = "pnpm",
		useESLintClass = false,
		experimental = {
			useFlatConfig = false,
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		quiet = false,
		onignoredfiles = "off",
		rulescustomizations = {},
		run = "ontype",
		problems = {
			shortentosingleline = false,
		},
		workingdirectories = { mode = "auto" },
		codeaction = {
			disablerulecomment = {
				enable = true,
				location = "separateline",
			},
			showdocumentation = {
				enable = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Enable formatting capability
		client.server_capabilities.document_formatting = true

		-- Create EslintFixAll command
		vim.api.nvim_buf_create_user_command(bufnr, "EslintFixAll", function()
			vim.lsp.buf.execute_command({
				command = "eslint.executeAutofix",
				arguments = {
					{
						uri = vim.uri_from_bufnr(bufnr),
						version = vim.lsp.util.buf_versions[bufnr],
					},
				},
			})
		end, {
			desc = "Fix all ESLint issues",
		})

		-- Auto-fix on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				local file_type = vim.bo.filetype
				local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
				local max_file_size = 1024 * 1024 -- 1MB

				if
					vim.tbl_contains(client.config.filetypes, file_type)
					and file_size > 0
					and file_size < max_file_size
				then
					pcall(function()
						vim.cmd("EslintFixAll")
					end)
				end
			end,
		})
	end,
}
