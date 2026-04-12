return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	lazy = true,
	build = ":TSUpdate",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function()
		vim.treesitter.language.register("markdown", "mdx")
		vim.treesitter.language.register("glimmer", "handlebars")

		local installed = require("nvim-treesitter").get_installed()
		local installed_set = {}
		for _, lang in ipairs(installed) do
			installed_set[lang] = true
		end

		local ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"tsx",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"lua",
			"vim",
			"gitignore",
			"glimmer",
		}

		local to_install = vim.tbl_filter(function(lang)
			return not installed_set[lang]
		end, ensure_installed)

		if #to_install > 0 then
			vim.cmd("TSInstall " .. table.concat(to_install, " "))
		end
	end,
}
