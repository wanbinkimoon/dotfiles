return {
	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = { "Mason", "MasonUpdate" },
		config = function()
			require("mason").setup()
		end,
	},
}
