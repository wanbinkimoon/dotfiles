-- NOTE: This is a workaround for the issue with the <C-i> key not working as expected in some terminal emulators.
-- This is due because <C-i> is often interpreted as a tab character, since older keyboards didn't have a dedicated tab key
vim.keymap.set("n", "<C-p>", "<C-i>", { noremap = true, desc = "Jump forward" })

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

-- Move lines up and down
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")

-- Splits
vim.keymap.set("n", "sl", ":vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "sj", ":split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "sq", ":q<CR>", { desc = "Close pane" })

-- Tabs
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

-- Quickfix
vim.keymap.set("n", "cq", "<cmd>copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "cQ", "<cmd>cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set("n", "cn", "<cmd>cnext<CR>", { desc = "Next quickfix" })
vim.keymap.set("n", "cp", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
