return {
	"MagicDuck/grug-far.nvim",
	lazy = true,
	event = "BufReadPost",
	cmd = { "GrugFar" },
	keys = {
		{ "<leader>sr", "<cmd>GrugFar ripgrep<CR>", desc = "[S]earch: search and replace" },
	},
}
