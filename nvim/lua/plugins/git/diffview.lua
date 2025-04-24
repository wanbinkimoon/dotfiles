return {
	"sindrets/diffview.nvim",
	enabled = false,
	cmd = "DiffviewOpen",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("diffview").setup({
			view = {
				default = {
					layout = "diff2_horizontal", -- Horizontal diff layout
				},
				merge_tool = {
					layout = "diff3_horizontal", -- Horizontal 3-way merge view
				},
			},
			file_panel = {
				listing_style = "tree", -- One of 'list' or 'tree'
				tree_options = { -- Only applicable when listing_style is 'tree'
					flatten_dirs = true,
					folder_statuses = "always",
				},
			},
		})
	end,
}
