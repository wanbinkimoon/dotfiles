return {
	"folke/flash.nvim",
	opts = {
		modes = {
			char = {
				jump_labels = true,
			},
		},
	},
	keys = {
		{
			"ss",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
		{
			"st",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash Treesitter",
		},
	},
}
