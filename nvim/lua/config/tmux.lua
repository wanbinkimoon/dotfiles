-- https://github.com/ofirgall/tmux-window-name?tab=readme-ov-file#installation
local uv = vim.uv

vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
	callback = function()
		if vim.env.TMUX_PLUGIN_MANAGER_PATH then
			uv.spawn(vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py", {})
		end
	end,
})
