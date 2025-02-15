return {
	"numToStr/Comment.nvim",
	event = "BufRead",
	opts = {},
	config = function()
		require("Comment").setup()
	end,
}
