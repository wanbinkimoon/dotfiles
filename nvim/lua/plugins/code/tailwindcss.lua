return {
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		ft = { "html", "css", "javascript", "typescript" }, -- Load only for these filetypes
		event = "BufRead", -- Load only when a file is opened
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
	{
		"luckasRanarison/tailwind-tools.nvim",
		ft = { "html", "css", "javascript", "typescript" }, -- Load only for these filetype
		event = "BufRead", -- Load only when a file is opened
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim", -- optional
			"neovim/nvim-lspconfig", -- optional
		},
		opts = {}, -- your configuration
	},
}
