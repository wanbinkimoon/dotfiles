-- Split (for some reason we need to specify the Shift key)
vim.keymap.set("n", "sl", ":vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "sj", ":split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "sq", ":q<CR>", { desc = "Close pane" })

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
