return {
	{
		enabled = true,
		"luukvbaal/statuscol.nvim",
		lazy = true,
		event = "BufEnter",
		dependencies = {
			{ "lewis6991/gitsigns.nvim", lazy = true },
		},
		config = function()
			require("statuscol").setup({})
			local builtin = require("statuscol.builtin")

			local cfg = {
				setopt = true, -- Whether to set the 'statuscolumn' option, may be set to false for those who
				thousands = false, -- or line number thousands separator string ("." / ",")
				relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set
				ft_ignore = nil, -- lua table with 'filetype' values for which 'statuscolumn' will be unset
				bt_ignore = nil, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
				segments = {
					{
						text = { builtin.foldfunc, "  " },
						click = "v:lua.ScFa",
						hl = "Comment",
					},
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						sign = { name = { "GitSign*" } },
						click = "v:lua.ScSa",
					},
					{
						text = { builtin.lnumfunc, "  " },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
				},
				clickmod = "c", -- modifier used for certain actions in the builtin clickhandlers:
				-- "a" for Alt, "c" for Ctrl and "m" for Meta.
				clickhandlers = { -- builtin click handlers
					Lnum = builtin.lnum_click,
					FoldClose = builtin.foldclose_click,
					FoldOpen = builtin.foldopen_click,
					FoldOther = builtin.foldother_click,
					DapBreakpointRejected = builtin.toggle_breakpoint,
					DapBreakpoint = builtin.toggle_breakpoint,
					DapBreakpointCondition = builtin.toggle_breakpoint,
					DiagnosticSignError = builtin.diagnostic_click,
					DiagnosticSignHint = builtin.diagnostic_click,
					DiagnosticSignInfo = builtin.diagnostic_click,
					DiagnosticSignWarn = builtin.diagnostic_click,
					GitSignsTopdelete = builtin.gitsigns_click,
					GitSignsUntracked = builtin.gitsigns_click,
					GitSignsAdd = builtin.gitsigns_click,
					GitSignsChange = builtin.gitsigns_click,
					GitSignsChangedelete = builtin.gitsigns_click,
					GitSignsDelete = builtin.gitsigns_click,
					gitsigns_extmark_signs_ = builtin.gitsigns_click,
				},
				fold = {
					width = 1, -- current width of the fold column
					close = "", -- foldclose
					open = "", -- foldopen
					sep = " ", -- foldsep
				},
			}

			require("statuscol").setup(cfg)

			local id = vim.api.nvim_create_augroup("statuscol", {})
			vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
				group = id,
				callback = function()
					if vim.api.nvim_buf_get_option(0, "ft") == "NvimTree" then
						vim.opt_local.statuscolumn = ""
					end

					if vim.api.nvim_buf_get_option(0, "ft") == "aerial" then
						vim.opt_local.statuscolumn = " "
					end

					if vim.api.nvim_buf_get_option(0, "ft") == "Outline" then
						vim.opt_local.statuscolumn = " "
					end
				end,
			})
		end,
	},
}
