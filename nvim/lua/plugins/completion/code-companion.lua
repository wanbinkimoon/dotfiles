return {
	"olimorris/codecompanion.nvim",
	enabled = true,
	event = { "InsertEnter", "LspAttach" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
	},
	keymaps = {
		{ "<leader>cc", "<CMD>:CodeCompanionChat<CR>", desc = "Open CodeCompanion chat" },
		{ "<leader>ci", "<CMD>:CodeCompanion<CR>", desc = "CodeCompanion inline assistant" },
		{ "<leader>cp", "<CMD>:CodeCompanionActions<CR>", desc = "CodeCompanion actions palette" },
		{ "<leader>ce", "<CMD>:CodeCompanion /explain<CR>", desc = "Explain code", mode = "v" },
	},
	opts = {
		strategies = {
			inline = {
				adapter = "anthropic",
			},
			chat = {
				adapter = "anthropic",
				keymaps = {
					send = {
						modes = { n = "<C-a>", i = "<C-a>" },
					},
				},
				tools = {},
			},
			display = {
				diff = {
					provider = "mini_diff", -- default|mini_diff
				},
			},
		},
		extensions = {},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)
		local modes = { "n", "v" }
		vim.keymap.set(modes, "<leader>cc", "<CMD>:CodeCompanionChat<CR>", { desc = "Open CodeCompanion chat" })
		vim.keymap.set(modes, "<leader>ci", "<CMD>:CodeCompanion<CR>", { desc = "CodeCompanion inline assistant" })
		vim.keymap.set(modes, "<leader>cp", "<CMD>:CodeCompanionActions<CR>", { desc = "CodeCompanion palette" })
		vim.keymap.set(modes, "<leader>ce", "<CMD>:CodeCompanion /explain<CR>", { desc = "Explain code" })
	end,
}
