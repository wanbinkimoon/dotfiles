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
vim.opt.splitright = true
-- WARN: this option collapse the command line.
vim.opt.cmdheight = 0

vim.wo.foldcolumn = "1"
vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99

vim.g.loaded_man = 1 -- Disable :Man
vim.g.loaded_spellfile = 1 -- Disable spellfile.vim

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

-- NOTE: This is a workaround for the issue with the <C-i> key not working as expected in some terminal emulators.
-- This is due because <C-i> is often interpreted as a tab character, since older keyboards didn't have a dedicated tab key.
vim.keymap.set("n", "<C-p>", "<C-i>", { noremap = true, desc = "Jump forward" })
