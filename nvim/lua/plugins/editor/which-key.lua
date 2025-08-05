return {
	"folke/which-key.nvim",
	event = "UIEnter",
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "classic",
		delay = 1000,
	},
	keys = {
		{ "<leader>?", "<cmd>WhichKey<cr>", desc = "Buffer Local Keymaps (which-key)" },
	},
}
