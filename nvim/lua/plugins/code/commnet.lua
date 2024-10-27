return {
	"numToStr/Comment.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {},
	config = function()
		require("Comment").setup()
	end,
}
