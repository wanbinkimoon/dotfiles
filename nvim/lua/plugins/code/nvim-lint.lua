return {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
	config = function()
		local lint = require("lint")
		
		-- Configure eslint_d for monorepo support with @repo scoped packages
		local eslint_d = lint.linters.eslint_d
		eslint_d.args = vim.list_extend({
			"--no-warn-ignored",
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
		}, {})
		
		-- Override cwd to use workspace root for @repo package resolution
		eslint_d.cwd = function()
			local function find_workspace_root(path)
				local current = path or vim.fn.getcwd()
				while current and current ~= "/" do
					if vim.fn.filereadable(current .. "/pnpm-workspace.yaml") == 1 
						or vim.fn.filereadable(current .. "/yarn.lock") == 1 
						or vim.fn.filereadable(current .. "/lerna.json") == 1 then
						return current
					end
					current = vim.fn.fnamemodify(current, ":h")
				end
				return vim.fn.getcwd() -- fallback to current directory
			end
			return find_workspace_root(vim.fn.expand("%:p:h"))
		end
		
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			handlebars = { "djlint" },
			["javascript.glimmer"] = { "ember", "djlint" },
		}
		
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "BufReadPost" }, {
			callback = function()
				-- Only lint if we're in a supported filetype
				local ft = vim.bo.filetype
				if lint.linters_by_ft[ft] then
					lint.try_lint()
				end
			end,
		})
	end,
}
