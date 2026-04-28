return {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
	config = function()
		local lint = require("lint")

		-- Linting via LSP only for JS/TS. Keeping plugin for non-JS linters.
		lint.linters_by_ft = {
			handlebars = { "djlint" },
			["javascript.glimmer"] = { "ember", "djlint" },
		}

		-- Lint on save + initial read (sufficient for non-JS filetypes)
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			callback = function()
				local ft = vim.bo.filetype
				if lint.linters_by_ft[ft] then
					lint.try_lint()
				end
			end,
		})
	end,
}
