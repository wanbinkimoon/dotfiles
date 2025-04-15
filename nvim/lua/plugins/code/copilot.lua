return {
	{
		"github/copilot.vim",
		event = { "InsertEnter", "LspAttach" },
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		event = { "InsertEnter", "LspAttach" },
		opts = {
			model = "claude-3.7-sonnet",
			context = "#buffer",
		},
		keys = {
			{ "<leader>cc", "<cmd>:CopilotChatToggle<cr>", desc = "Copilot Chat" },
		},
	},
}
