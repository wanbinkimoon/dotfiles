return {
	"tpope/vim-fugitive",
	cmd = { "Git", "Gdiffsplit" }, -- Load on demand
	keys = {
		{ "gs", "<cmd>:Git<CR>", desc = "[G]it: open git status" },
		{ "gB", "<cmd>:Git blame<CR>", desc = "[G]it: blame", { noremap = true } },
		{ "gd", "<cmd>:Gdiff<CR>", desc = "[G]it: diff" },
		{ "gD", "<cmd>:Gdiffsplit<CR>", desc = "[G]it: diff split" },
		{ "gk", "<cmd>:diffget //3<CR>", desc = "[G]it: diff get from right" },
		{ "gj", "<cmd>:diffget //2<CR>", desc = "[G]it: diff get from left" },
		{ "gv", "<cmd>DiffviewOpen<CR>", desc = "[G]it: open diff view" },
		{ "gc", "<cmd>DiffviewClose<CR>", desc = "[G]it: close diff view" },
	},
	config = function()
		vim.g.fugitive_git_command = "git"
		vim.g.fugitive_blame_line_relativenumber = 1
	end,
}
