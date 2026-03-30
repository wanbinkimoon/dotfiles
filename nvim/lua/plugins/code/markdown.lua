return {
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			preset = "obsidian",
			render_modes = { "n", "c", "t" },
		},
	},
}
