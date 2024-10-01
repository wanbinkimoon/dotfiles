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

      local options = {}

      -- Optione: Extensions
      options.extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
        ["live_grep_args"] = {
          auto_qoting = true,
        },
      }

      telescope.setup(options)

      -- Keymaps
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch: [F]iles" })
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "[S]earch: Oldfiles " })
      vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch: [B]uffers" })

      local git_branch = require("git_branch")
      vim.keymap.set({ "n", "v" }, "<leader>sd", git_branch.files, { desc = "[S]earch: Git [D]iff" })

      local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
      vim.keymap.set(
        "n",
        "<leader>sg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args({opts = { search_dirs = true }})<CR>",
        { desc = "[S]earch: Live [G]rep" }
      )
      vim.keymap.set(
        { "n", "v" },
        "<leader>sw",
        live_grep_args_shortcuts.grep_word_under_cursor,
        { desc = "[S]earch: [W]ord" }
      )
      vim.keymap.set(
        "v",
        "<leader>ss",
        live_grep_args_shortcuts.grep_visual_selection,
        { noremap = true, silent = true, desc = "[S]earch current [S]election" }
      )

      vim.keymap.set(
        { "n", "v" },
        "gd",
        builtin.lsp_definitions,
        { desc = "Search: LSP [D]efinitions", remap = true }
      )
      vim.keymap.set({ "n", "v" }, "gr", builtin.lsp_references, { desc = "Search: LSP [R]eferences" })
      vim.keymap.set({ "n", "v" }, "gi", builtin.lsp_implementations, { desc = "Search: LSP [I]mplementations" })
      vim.keymap.set(
        { "n", "v" },
        "gt",
        builtin.lsp_type_definitions,
        { desc = "Search: LSP [T]ype Definitions" }
      )
      vim.keymap.set({ "n", "v" }, "gs", builtin.lsp_document_symbols, { desc = "Search: LSP [S]ymbols" })

      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      telescope.load_extension("git_branch")
    end,
  },
}
