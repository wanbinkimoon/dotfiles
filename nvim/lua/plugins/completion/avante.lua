return {
	{
		"yetone/avante.nvim",
		event = "BufRead",
		opts = {
			provider = "claude",

			mappings = {
				submit = {
					insert = "<C-a>",
				},
			},
			windows = {
				width = 50,
			},
		},
		build = "make",
		dependencies = {
			-- "stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
}
