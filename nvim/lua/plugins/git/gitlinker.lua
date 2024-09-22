return {
	{
		"ruifm/gitlinker.nvim",
		config = function()
			local gitlinker = require("gitlinker")
			gitlinker.setup({
				callbacks = {
					["github.com"] = require("gitlinker.hosts").get_github_type_url,
					["gitlab.com"] = require("gitlinker.hosts").get_gitlab_type_url,
					["gitlab.qonto.co"] = require("gitlinker.hosts").get_gitlab_type_url,
				},
			})
		end,
	},
}
