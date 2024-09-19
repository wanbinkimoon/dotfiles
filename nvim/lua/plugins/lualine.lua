return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
      },
      sections = {
        lualine_c = { { "filename", path = 3 } },
        lualine_x = { "filetype" },
        lualine_y = { "encoding", "fileformat" },
      },
    })
  end,
}
