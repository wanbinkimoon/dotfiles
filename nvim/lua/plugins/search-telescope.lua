return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "mrloop/telescope-git-branch.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          ["live_grep_args"] = {
            auto_qoting = true,
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch: [F]iles" })
      vim.keymap.set(
        "n",
        "<leader>sg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args({opts = { search_dirs = true }})<CR>",
        { desc = "[S]earch: Live [G]rep" }
      )
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Search Opened" })
      vim.keymap.set({ "n", "v" }, "<leader>sd", function()
        require("git_branch").files()
      end, { desc = "[S]earch: Git [D]iff" })

      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("git_branch")
    end,
  },
}
