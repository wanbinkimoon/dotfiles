return {
	"numToStr/Comment.nvim",
	event = "BufRead",
	opts = {},
	keys = {
		{ "gb", false, mode = { "n", "x" } },
	},
	config = function()
		require("Comment").setup()
	end,
}
