return {
	{
		"ruifm/gitlinker.nvim",
		lazy = true,
		event = "BufRead",
		config = function()
			local gitlinker = require("gitlinker")
			gitlinker.setup({
				callbacks = {
					["github.com"] = require("gitlinker.hosts").get_github_type_url,
					["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
					["gitlab.qonto.co"] = require("gitlinker.hosts").get_gitlab_type_url,
				},
			})

			vim.keymap.set(
				"n",
				"<leader>gy",
				'<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
				{ silent = true, desc = "GitLinker: open in browser" }
			)
			vim.keymap.set(
				"v",
				"<leader>gy",
				'<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
				{ desc = "GitLinker: open in browser" }
			)
		end,
	},
}
