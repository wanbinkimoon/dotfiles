-- lua/config/autoreload.lua
return {
	setup = function()
		vim.opt.autoread = true
		-- Set updatetime (default is 4000 ms = 4s)
		vim.opt.updatetime = 1000 -- Set to 1000ms (1s)

		local augroup = vim.api.nvim_create_augroup("AutoReload", { clear = true })

		vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
			group = augroup,
			pattern = "*",
			callback = function()
				if vim.fn.mode() ~= "c" then
					vim.cmd("checktime")
				end
			end,
		})

		vim.api.nvim_create_autocmd("FileChangedShellPost", {
			group = augroup,
			pattern = "*",
			callback = function()
				vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
			end,
		})
	end,
}
