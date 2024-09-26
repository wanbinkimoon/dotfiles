return {
  "tpope/vim-fugitive", -- Git wrapper
  keys = {
    { "<leader>gs", "<cmd>:Git<CR>",       desc = "[G]it: open git status" },
    -- { "<leader>gc", "<cmd>:Git commit<CR>", desc = "[G]it: commit" },
    -- { "<leader>gp", "<cmd>:Git push<CR>", desc = "[G]it: push" },
    -- { "<leader>gl", "<cmd>:Git pull<CR>", desc = "[G]it: pull" },
    { "<leader>gb", "<cmd>:Git blame<CR>", desc = "[G]it: blame" },
  },                                           -- optional
  config = function()
    vim.g.fugitive_git_command = "git"         -- Use system git
    vim.g.fugitive_blame_line_relativenumber = 1 -- Show relative line numbers in blame
  end,                                         -- optional
}
