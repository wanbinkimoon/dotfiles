return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
    end,
  },
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <author> • <date> • <summary> • <sha>",
      date_format = "%d/%m/%y %H:%M:%S",
      virtual_text_column = 1,
    },
    -- config = function()
    -- 	require("git-blame").setup()
    -- end,
  },
  {
    "ruifm/gitlinker.nvim",
    config = function()
      require("gitlinker").setup({
        opts = {
          action_callback = require("gitlinker.actions").open_in_browser,
          print_url = true,
        },
        callbacks = {
          ["github"] = require("gitlinker.hosts").get_github_type_url,
          ["gitlab"] = require("gitlinker.hosts").get_gitlab_type_url,
          ["gitlab.qonto.co"] = require("gitlinker.hosts").get_gitlab_type_url,
        },
      })
    end,
  },
}
