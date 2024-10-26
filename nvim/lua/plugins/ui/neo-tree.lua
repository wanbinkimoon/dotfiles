return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "sindrets/diffview.nvim",
  },
  config = function()
    local icons = require("config.icons")
    local opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      enable_git_status = true,
      enable_diagnostics = false,
      indent = {
        indent_size = 2,
        padding = 0, -- extra padding on left hand side
        -- indent guides
        -- with_markers = true,
        -- indent_marker = "│",
        -- last_indent_marker = "└",
        -- highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        -- with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        -- expander_collapsed = "",
        -- expander_expanded = "",
        -- expander_highlight = "NeoTreeExpander",
      },
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
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"] = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",

            ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
            ["oc"] = { "order_by_created", nowait = false },
            ["od"] = { "order_by_diagnostics", nowait = false },
            ["om"] = { "order_by_modified", nowait = false },
            ["on"] = { "order_by_name", nowait = false },
            ["os"] = { "order_by_size", nowait = false },
            ["ot"] = { "order_by_type", nowait = false },
          },
        },
      },
      default_component_configs = {
        modified = {
          -- symbol = "",
          symbol = "",
          highlight = "NeoTreeModified",
        },
        git_status = {
          symbols = {
            -- Change type
            added = icons.git.Add,
            deleted = icons.git.Remove,
            modified = icons.git.Mod,
            renamed = icons.git.Rename,
            -- Status type
            untracked = icons.git.Untrack,
            ignored = icons.git.Ignore,
            unstaged = "",
            -- staged = icons.git.Staged,
            staged = "",
            conflict = icons.git.Conflict,
          },
          align = "right",
        },
      },
    }
    require("neo-tree").setup(opts)

    vim.keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>", { desc = "Neotree [e]xplore" })
    vim.keymap.set("n", "<leader>b", ":Neotree buffers reveal float<CR>", { desc = "NeoTree [b]uffers" })
    vim.keymap.set("n", "<leader>G", ":Neotree float git_status<CR>", { desc = "NeoTree [G]it status" })
  end,
}
