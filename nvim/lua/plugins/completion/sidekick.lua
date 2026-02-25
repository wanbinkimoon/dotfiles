return {
	{
		"folke/sidekick.nvim",
		opts = {
			-- add any options here
			cli = {
				backend = "tmux",
				enabled = false,
			},
		},
		keys = {
			{
				"<c-.>",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>cc",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>cx",
				function()
					require("sidekick.cli").prompt()
				end,
				desc = "Sidekick Prompt",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>cf",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
		},
	},
	{
		"cajames/copy-reference.nvim",
		opts = {}, -- optional configuration
		keys = {
			{ "yr", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
			{ "yrr", "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
		},
	},
}
