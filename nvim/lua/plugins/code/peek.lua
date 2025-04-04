return {
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			local opts = {
				-- Default options
				auto_load = true, -- When true, a hidden peek window will open for markdown files when entering the buffer
				close_on_bdelete = true, -- Close the preview window on buffer delete
				syntax = true, -- Enable syntax highlighting in the preview markdown
				theme = "dark", -- Use dark theme for preview window
				update_on_change = true, -- Update preview window on change
				app = "browser", -- Use browser as the preview app
				filetype = { "markdown" }, -- List of filetypes to use peek for
			}
			require("peek").setup(opts)

			-- Alternative way to create user commands
			-- Uncomment if you prefer this method
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},
}
