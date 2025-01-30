return {
	{
		"github/copilot.vim",
	},
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		event = "BufReadPre",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		enabled = false,
		lazy = true,
		event = "BufReadPre",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
