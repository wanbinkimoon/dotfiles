local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.loader.enable()

require("lazy").setup({
	{ import = "plugins.code" },
	{ import = "plugins.completion" },
	{ import = "plugins.editor" },
	{ import = "plugins.git" },
	{ import = "plugins.navigation" },
	{ import = "plugins.ui" },
}, {
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	ui = {
		border = "single",
	},
	defaults = {
		lazy = true,
	},
})
