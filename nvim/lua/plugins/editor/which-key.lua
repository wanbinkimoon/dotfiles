return {
	"folke/which-key.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "classic",
		delay = 500,
	},
	keys = {
		{ "<leader>?", "<cmd>WhichKey<cr>", desc = "Buffer Local Keymaps (which-key)" },
	},
}
