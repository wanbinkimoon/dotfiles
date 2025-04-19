return {
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		ft = { "html", "css", "javascript", "typescript" },
		event = "BufRead",
		lazy = true,
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = { "html", "css", "javascript", "typescript" },
		event = "BufRead",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
