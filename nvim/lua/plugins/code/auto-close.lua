return {
	"m4xshen/autoclose.nvim",
	lazy = true,
	event = "BufRead",
	config = function()
		require("autoclose").setup()
	end,
}
