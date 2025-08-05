---@type vim.lsp.Config
return {
	cmd = { "eslint", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
	root_markers = {
		".eslintrc.js",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc",
		"package.json",
	},
	settings = {
		eslint = {
			workingDirectories = { mode = "auto" },
			autoFixOnSave = true,
			packageManager = "pnpm",
		},
	},
	on_attach = function(client)
		client.server_capabilities.document_formatting = true
		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				-- Get current file type
				local file_type = vim.bo.filetype

				-- Check file size (skip for very large files)
				local file_size = vim.fn.getfsize(vim.fn.expand("%:p"))
				local max_file_size = 1024 * 1024 -- 1MB

				-- Apply ESLint for specific file types and small files
				if vim.tbl_contains(client.config.filetypes, file_type) and file_size > 0 and file_size < max_file_size then
					vim.cmd("EslintFixAll")
				end

				-- Format all file types
				vim.cmd("Format")
			end,
		})
	end,
}