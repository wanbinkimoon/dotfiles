return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch: [F]iles" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch: Live [G]rep" })
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Search Opened" })

      require("telescope").load_extension("ui-select")
    end,
  },
}
