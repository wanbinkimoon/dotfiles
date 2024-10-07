return {
  "MagicDuck/grug-far.nvim",
  keys = {
    {
      "<leader>sr",
      "<cmd>:lua require('grug-far').open({ transient = true })<CR>",
      desc = "[S]earch: search and replace",
    },
  },
  config = function()
    require("grug-far").setup({})
  end,
}
