return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo_comments = require("todo-comments")

		-- keymaps
		local keymap = vim.keymap

		keymap.set("n", "]t", function()
			todo_comments.jump_next()
		end, { desc = "Next todo comment" })

		keymap.set("n", "[t", function()
			todo_comments.jump_prev()
		end, { desc = "Previous todo comment" })

		-- :TodoTelescope keywords=TODO,FIX
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope keywords=TODO,FIX <cr>", { desc = "Find todo comments" })

		-- :Trouble todo
		keymap.set("n", "<leader>xt", "<cmd>Trouble todo<cr>", { desc = "Find todo comments" })

		todo_comments.setup()
	end,
}
