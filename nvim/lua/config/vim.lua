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
-- vim.opt.cmdheight = 0

vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

vim.g.loaded_man = 1 -- Disable :Man
vim.g.loaded_spellfile = 1 -- Disable spellfile.vim

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
