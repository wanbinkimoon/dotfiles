vim.cmd("set softtabstop=2")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.showmode = false
vim.o.swapfile = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.cursorline = true
vim.wo.number = true
vim.o.scrolloff = 10
vim.o.showtabline = 0
vim.o.splitright = true
vim.o.winborder = "rounded"

-- WARN: this option collapse the command line.
-- vim.opt.cmdheight = 0

vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

vim.g.loaded_man = 1 -- Disable :Man
vim.g.loaded_spellfile = 1 -- Disable spellfile.vim
vim.g.loaded_ruby_provider = 0 -- Disable Ruby provider
vim.g.loaded_perl_provider = 0 -- Disable Perl provider
vim.opt.autoread = true
-- default is 4000 ms
vim.opt.updatetime = 1000

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
