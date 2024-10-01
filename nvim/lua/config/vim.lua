vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.breakindent = true
vim.opt.undofile = true
-- vim.opt.cursorline = true
vim.wo.number = true
vim.opt.scrolloff = 10
vim.opt.showtabline = 0

-- Disable arrow keys
-- vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Remove search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Add new line remaning in normal mode
vim.keymap.set("n", "<leader>o", "o<ESC>k", { desc = "Add new line below" })
vim.keymap.set("n", "<leader>O", "O<ESC>j", { desc = "Add new line above" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim.cmd([[autocmd VimEnter * Neotree]])
