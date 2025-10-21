---@type vim.lsp.Config
local eslint_config_files = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_dir = function(bufnr, on_dir)
		local root_markers = { "pnpm-workspace.yaml", "yarn.lock", "lerna.json", ".git", "package.json" }
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
		on_dir(project_root)
		-- return project_root
	end,
	workspace_required = true,
	on_attach = function(client, buffer)
		client.server_capabilities.document_formatting = true
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = buffer,
			callback = function(event)
				local namespace = vim.lsp.diagnostic.get_namespace(client.id, true)
				local diagnostics = vim.diagnostic.get(event.buf, { namespace = namespace })
				local eslint = function(formatter)
					return formatter.name == "eslint"
				end
				if #diagnostics > 0 then
					vim.lsp.buf.format({ async = false, filter = eslint })
				end
			end,
		})
	end,
	settings = {
		validate = "on",
		packageManager = nil,
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
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onSave",
		problems = {
			shortenToSingleLine = false,
		},
		-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
		-- This path is relative to the workspace folder (root dir) of the server instance.
		nodePath = "",
		-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
		workingDirectory = { mode = "auto" },
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	before_init = function(_, config)
		-- The "workspaceFolder" is a VSCode concept. It limits how far the
		-- server will traverse the file system when locating the ESLint config
		-- file (e.g., .eslintrc).
		local root_dir = config.root_dir

		if root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = root_dir,
				name = vim.fn.fnamemodify(root_dir, ":t"),
			}

			-- Support flat config files
			-- They contain 'config' in the file name
			local flat_config_files = vim.tbl_filter(function(file)
				return file:match("config")
			end, eslint_config_files)

			for _, file in ipairs(flat_config_files) do
				local found_files = vim.fn.globpath(root_dir, file, true, true)

				-- Filter out files inside node_modules
				local filtered_files = {}
				for _, found_file in ipairs(found_files) do
					if string.find(found_file, "[/\\]node_modules[/\\]") == nil then
						table.insert(filtered_files, found_file)
					end
				end

				if #filtered_files > 0 then
					config.settings.experimental = config.settings.experimental or {}
					config.settings.experimental.useFlatConfig = true
					break
				end
			end

			-- Support Yarn2 (PnP) projects
			local pnp_cjs = root_dir .. "/.pnp.cjs"
			local pnp_js = root_dir .. "/.pnp.js"
			if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
				local cmd = config.cmd
				config.cmd = vim.list_extend({ "yarn", "exec" }, cmd)
			end
		end
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
}
