return {
	{
		"m4xshen/autoclose.nvim",
		lazy = true,
		event = "InsertEnter",
		config = function()
			local autoclose = require("autoclose")
			autoclose.setup({
				options = {
					pair_spaces = true,
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue" },
		config = function()
			require("nvim-ts-autotag").setup({
				filetypes = {
					"html",
					"xml",
					"javascriptreact",
					"typescriptreact",
					"vue",
				},
			})
		end,
	},
}
