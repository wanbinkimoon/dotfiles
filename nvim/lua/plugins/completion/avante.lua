return {
	"ghosert/avante.nvim",
	branch = "main",
	event = "VeryLazy",
	lazy = false,
	version = false,
	build = "make",
	opts = {
		provider = "claude",
		auto_suggestions_provider = "claude",
		providers = {
			claude = {
				auth_type = "max", -- Set to "max" to sign in with Claude Pro/Max subscription
			},
		},
		acp_providers = {
			["claude-code"] = {
				command = "npx",
				args = { "@zed-industries/claude-code-acp" },
				env = {
					NODE_NO_WARNINGS = "1",
					-- ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
					CLAUDE_CODE_OAUTH_TOKEN = "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",
				},
			},
		},
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
		},
		mappings = {
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			suggestion = {
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-a>",
			},
		},
		hints = { enabled = true },
		windows = {
			position = "right",
			wrap = true,
			width = 30,
			sidebar_header = {
				align = "center",
				rounded = true,
			},
		},
		highlights = {
			diff = {
				current = "DiffText",
				incoming = "DiffAdd",
			},
		},
		diff = {
			autojump = true,
			list_opener = "copen",
		},
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "Avante", "markdown" },
		},
	},
}
