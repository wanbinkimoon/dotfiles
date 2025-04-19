return {
	"mfussenegger/nvim-lint",
	event = "BufReadPre",
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			handlebars = { "djlint" },
			["javascript.glimmer"] = { "ember", "djlint" },
		}
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
