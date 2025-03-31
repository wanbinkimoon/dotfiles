vim.keymap.set("n", "<tab>n", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
vim.keymap.set("n", "<tab>x", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<tab>l", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<tab><tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<tab>h", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<tab>b", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move

-- Go to tab number with <tab> + number 1 ... 9
for i = 1, 9, 1 do
	vim.keymap.set("n", "<tab>" .. i, "<cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end
