return {
	"folke/which-key.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "helix",
		delay = function(ctx)
			return 500
		end,
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
