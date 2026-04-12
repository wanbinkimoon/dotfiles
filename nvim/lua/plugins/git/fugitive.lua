return {
	enabled = true,
	"tpope/vim-fugitive",
	cmd = { "Git", "G" }, -- Load on demand
	keys = {
		{ "Gs", "<cmd>:Git<CR>", desc = "[G]it: open git status" },
		{ "Gb", "<cmd>:Git blame<CR>", desc = "[G]it: blame", { noremap = true } },
		{ "Gd", "<cmd>:Gdiff<CR>", desc = "[G]it: diff" },
		{ "Gk", "<cmd>:diffget //3<CR>", desc = "[G]it: diff get from right" },
		{ "Gj", "<cmd>:diffget //2<CR>", desc = "[G]it: diff get from left" },
		{ "Gv", "<cmd>:Gdiff<CR>", desc = "[G]it: open vertical diff" },
	},
	config = function()
		vim.g.fugitive_git_command = "git"
		vim.g.fugitive_blame_line_relativenumber = 1
	end,
}
