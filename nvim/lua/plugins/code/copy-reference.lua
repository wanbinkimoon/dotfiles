return {
  {
    "cajames/copy-reference.nvim",
    opts = { register = "+" },
    keys = {
      { "<leader>yr", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
      { "<leader>yrr", "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
    },
  }
}
