return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonUpdate" },
	config = function()
		require("mason").setup()
	end,
}
