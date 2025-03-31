return {
	{
		"axkirillov/hbac.nvim",
		event = "BufRead",
		config = function()
			require("hbac").setup({
				autoclose = true, -- set autoclose to false if you want to close manually
				threshold = 5, -- Lower threshold from 10 to 5
				close_command = function(bufnr)
					-- Don't close modified buffers
					if not vim.api.nvim_buf_get_option(bufnr, "modified") then
						vim.api.nvim_buf_delete(bufnr, {})
					end
				end,
				close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
				priority = {
					-- Define buffer priority to keep important buffers open
					filetype = {
						"TelescopePrompt", -- Keep telescope buffers
						"neo-tree",        -- Keep file explorer
						"fugitive",        -- Keep git buffers
						"lazy",            -- Keep package manager
					},
					patterns = {
						-- Keep configuration files open
						"%.lua$",          -- Lua config files
						"%.md$",           -- Documentation
						"%.json$",         -- Important JSON files
					}
				},
				-- Track buffer usage more accurately
				tracking = {
					follow_current_file = true,  -- Track file switching
					update_on_insert = true,     -- Consider insert mode as activity
				}
			})
		end,
	},
}
