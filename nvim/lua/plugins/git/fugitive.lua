return {
	enabled = false,
	"tpope/vim-fugitive",
	cmd = { "Git", "G" }, -- Load on demand
	keys = {
		{ "gs", "<cmd>:Git<CR>", desc = "[G]it: open git status" },
		{ "gb", "<cmd>:Git blame<CR>", desc = "[G]it: blame", { noremap = true } },
		{ "gd", "<cmd>:Gdiff<CR>", desc = "[G]it: diff" },
		{ "gk", "<cmd>:diffget //3<CR>", desc = "[G]it: diff get from right" },
		{ "gj", "<cmd>:diffget //2<CR>", desc = "[G]it: diff get from left" },
		{ "gv", "<cmd>:Gdiff<CR>", desc = "[G]it: open vertical diff" },
	},
	config = function()
		vim.g.fugitive_git_command = "git"
		vim.g.fugitive_blame_line_relativenumber = 1
	end,
}
