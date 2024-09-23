return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "dokwork/lualine-ex" },
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
        component_separators = "/",
        section_separators = { left = "", right = "" },
        -- disabled_filetypes = { "neo-tree" },
        globalstatus = true,
      },
      sections = {
        -- lualine_c = { { "filename", path = 3 } },
        lualine_c = { { "ex.relative_filename" } },
        lualine_x = { "filetype" },
        lualine_y = { "encoding" },
      },
    })
  end,
}
