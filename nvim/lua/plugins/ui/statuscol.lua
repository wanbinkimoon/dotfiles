return {
	{
		enabled = true,
		"luukvbaal/statuscol.nvim",
		event = "BufReadPost",
		dependencies = { "lewis6991/gitsigns.nvim" },
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				ft_ignore = { "alpha", "neo-tree" },
				segments = {
					{
						text = { builtin.foldfunc },
						hl = "Comment",
						click = "v:lua.ScFa",
					},
					{
						text = { builtin.lnumfunc, " " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{
						sign = {
							namespace = { "gitsigns" },
							maxwidth = 1,
							colwidth = 1,
							auto = false,
							fillchar = "┃",
							fillcharhl = "LineNr",
						},
						click = "v:lua.ScSa",
					},
					{
						text = { " " },
					},
				},
			})
		end,
	},
}
