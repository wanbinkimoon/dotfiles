return {
	"alexghergh/nvim-tmux-navigation",
	cmd = {
		"NvimTmuxNavigateLeft",
		"NvimTmuxNavigateDown",
		"NvimTmuxNavigateUp",
		"NvimTmuxNavigateRight",
		"NvimTmuxNavigateLastActive",
		"NvimTmuxNavigateNext",
	},
	keys = {
		{ "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", desc = "Navigate to left tmux pane" },
		{ "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", desc = "Navigate to down tmux pane" },
		{ "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", desc = "Navigate to up tmux pane" },
		{ "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", desc = "Navigate to right tmux pane" },
		{ "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", desc = "Navigate to last active tmux pane" },
		{ "<C-Space>", "<Cmd>NvimTmuxNavigateNext<CR>", desc = "Navigate to next tmux pane" },
	},
	config = function()
		require("nvim-tmux-navigation").setup({})
		vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
		vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
		vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
		vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
		vim.keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", { silent = true })
		vim.keymap.set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", { silent = true })
	end,
}
