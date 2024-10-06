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
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
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
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          -- leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
      mappings = {
        ["l"] = "focus_preview",
        ["/"] = "fuzzy_finder",
        ["f"] = "filter_on_submit",
      },
    }
    require("neo-tree").setup(opts)

    vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { desc = "Neotree [e]xplore" })
    vim.keymap.set("n", "<leader>b", ":Neotree buffers reveal float<CR>", { desc = "NeoTree [b]uffers" })
  end,
}
