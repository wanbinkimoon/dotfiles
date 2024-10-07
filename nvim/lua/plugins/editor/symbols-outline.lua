return {
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		event = "BufRead",
		keys = {
			{ "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "[C]ode: [S]ymbols Outline" },
		},
		opts = {
			position = "right",
		},
	},
}
