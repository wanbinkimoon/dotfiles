return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		config = function()
			local gitsigns = require("gitsigns")

			gitsigns.setup({
				current_line_blame = true,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 500,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <abbrev_sha> - <summary>",
			})

			vim.keymap.set("n", "<leader>gi", gitsigns.diffthis, {
				desc = "Gitsigns: Diff this",
			})
			vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, {
				desc = "Gitsigns: Preview hunk",
			})
			vim.keymap.set("n", "<leader>gl", function()
				gitsigns.blame_line({ full = true })
			end, { desc = "Gitsigns: Blame line" })

			-- Navigation
			vim.keymap.set("n", "<localleader>]", function()
				if vim.wo.diff then
					vim.cmd.normal({ "<localleader>]", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			vim.keymap.set("n", "<localleader>[", function()
				if vim.wo.diff then
					vim.cmd.normal({ "<localleader>[", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			vim.keymap.set("n", "<localleader>r", gitsigns.reset_hunk)
		end,
	},
}
