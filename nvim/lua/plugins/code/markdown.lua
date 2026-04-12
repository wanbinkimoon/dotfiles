return {
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "opencode_output" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			preset = "obsidian",
			render_modes = { "n", "c", "t" },
			anti_conceal = { enabled = false },
			file_types = { "markdown", "opencode_output" },
		},
	},
}
