return {
	"m4xshen/autoclose.nvim",
	lazy = true,
	event = "BufRead",
	config = function()
		local autoclose = require("autoclose")
		autoclose.setup({
			options = {
				pair_spaces = true,
			},
		})
	end,
}
