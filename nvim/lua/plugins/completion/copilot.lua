return {
	{
		"github/copilot.vim",
		event = { "InsertEnter", "LspAttach" },
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			model = "claude-3.7-sonnet",
			context = "#buffer",
		},
		-- event = { "InsertEnter", "LspAttach" },
		cmd = "CopilotChat",
		keys = {
			{ "<leader>cc", "<cmd>:CopilotChatToggle<cr>", desc = "Copilot Chat" },
		},
	},
}
