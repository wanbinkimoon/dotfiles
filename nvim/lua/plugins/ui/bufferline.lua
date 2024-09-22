return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
    { "<leader>tp", "<Cmd>BufferLinePick<CR>",                 desc = "Tab Pick" },
    { "<leader>b[", "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
    { "<leader>b]", "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>",            desc = "Cycle to next buffer" },
    { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>",            desc = "Cycle to previous buffer" },
    { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>",         desc = "Go to buffer 1" },
    { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>",         desc = "Go to buffer 2" },
    { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>",         desc = "Go to buffer 3" },
    { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>",         desc = "Go to buffer 4" },
    { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>",         desc = "Go to buffer 5" },
    { "<leader>b6", "<cmd>BufferLineGoToBuffer 6<cr>",         desc = "Go to buffer 6" },
    { "<leader>b7", "<cmd>BufferLineGoToBuffer 7<cr>",         desc = "Go to buffer 7" },
    { "<leader>b8", "<cmd>BufferLineGoToBuffer 8<cr>",         desc = "Go to buffer 8" },
    { "<leader>b9", "<cmd>BufferLineGoToBuffer 9<cr>",         desc = "Go to buffer 9" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>",            desc = "Pick and close buffer" },
  },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "tabs",
        numbers = "ordinal", -- Can be "none", "ordinal", "buffer_id", "both"
        close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        indicator = {
          icon = "▎", -- This should be omitted if indicator style is not 'icon'
          style = "icon", -- can be 'icon' | 'underline' | 'none',
        },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 18,
        diagnostics = "nvim_lsp", -- Can be false | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = false,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,
        sort_by = "id",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true, -- use a "true" to enable the default, or set your own character
          },
        },
        always_show_bufferline = true,
        show_tab_indicators = true,
      },
    })
  end,
}
