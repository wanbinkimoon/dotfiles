-- set fold column to be always visible
vim.wo.foldcolumn = "1"

-- set foldmethod to be indent
vim.wo.foldmethod = "indent"

-- set foldlevel to be 99
vim.wo.foldlevel = 99

-- set keybinding to change fold method to be manual
vim.keymap.set("n", "<leader>zfm", ":set foldmethod=manual<CR>", { desc = "Change [F]old method to [M]anual" })

-- set keybinding to change fold method to be indent
vim.keymap.set("n", "<leader>zfi", ":set foldmethod=indent<CR>", { desc = "Change [F]old method to [I]ndent" })

-- set keybinding to change fold method to be syntax
vim.keymap.set("n", "<leader>zfs", ":set foldmethod=syntax<CR>", { desc = "Change [F]old method to [S]yntax" })

-- set keybinding to change fold method to be expr
vim.keymap.set("n", "<leader>zfe", ":set foldmethod=expr<CR>", { desc = "Change [F]old method to [E]xpr" })
