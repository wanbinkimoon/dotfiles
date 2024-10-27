return {
	{
		"simrat39/symbols-outline.nvim",
		lazy = true,
		event = "BufRead",
		cmd = "SymbolsOutline",
		keys = {
			{ "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "[C]ode: [S]ymbols Outline" },
		},
		opts = {
			position = "right",
		},
	},
}
