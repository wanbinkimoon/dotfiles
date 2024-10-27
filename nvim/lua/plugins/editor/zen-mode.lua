return {
	"folke/zen-mode.nvim",
	lazy = true,
	event = "VeryLazy",
	opts = {
		backdrop = 1,
		gitsigns = {
			enabled = false,
		}, -- disables git signs
		tmux = {
			enabled = true,
		}, -- disables the tmux statusline
		wezterm = {
			enabled = true,
			-- can be either an absolute font size or the number of incremental steps
			font = "+4", -- (10% increase per step)
		},
	},
}
