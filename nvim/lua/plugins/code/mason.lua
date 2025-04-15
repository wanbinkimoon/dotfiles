return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy", -- Load even later
    cmd = { "Mason", "MasonUpdate" },
    config = function()
      require("mason").setup()
    end,
  },
}
