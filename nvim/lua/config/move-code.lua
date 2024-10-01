-- Move lines up and down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
-- vim.keymap.set("n", "<D-S-j>", ":m .+1<CR>==")
-- vim.keymap.set("n", "<D-S-k>", ":m .-2<CR>==")
-- vim.keymap.set("v", "<D-S-j>", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "<D-S-k>", ":m '<-2<CR>gv=gv")