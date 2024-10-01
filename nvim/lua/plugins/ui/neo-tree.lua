return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git" },
          never_show = { ".DS_Store" },
          always_show = { ".env" },
        },
        follow_current_file = { leave_dirs_open = false, enabled = true },
      },
      buffers = { follow_current_file = { enable = true } },
    }
    require("neo-tree").setup(opts)
    vim.keymap.set("n", "<leader>1", ":Neotree filesystem toggle left<CR>", {})
    vim.keymap.set("n", "<leader>2", ":Neotree buffers reveal float<CR>", {})
  end,
}
