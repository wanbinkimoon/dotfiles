-- Split (for some reason we need to specify the Shift key)
vim.keymap.set("n", "sl", ":vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "sj", ":split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "sq", ":q<CR>", { desc = "Close pane" })
