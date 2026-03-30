return {
	{
		"Cannon07/claude-preview.nvim",
		lazy = false,
		config = function()
			require("claude-preview").setup({
				diff = {
					layout = "tab", -- "tab" (new tab) | "vsplit" (current tab)
					labels = { current = "CURRENT", proposed = "PROPOSED" },
					auto_close = true, -- close diff after accept
					equalize = true, -- 50/50 split widths
					full_file = true, -- show full file, not just diff hunks
				},
				highlights = {
					current = { -- CURRENT (original) side
						-- DiffAdd = { bg = "#4c2e2e" },
						-- DiffDelete = { bg = "#4c2e2e" },
						-- DiffChange = { bg = "#4c3a2e" },
						-- DiffText = { bg = "#5c3030" },
					},
					proposed = { -- PROPOSED side
						-- DiffAdd = { bg = "#2e4c2e" },
						-- DiffDelete = { bg = "#4c2e2e" },
						-- DiffChange = { bg = "#2e3c4c" },
						-- DiffText = { bg = "#3e5c3e" },
					},
				},
			})
		end,
	},
}
