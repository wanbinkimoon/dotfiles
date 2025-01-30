return {
	"felipejz/i18n-menu.nvim",
	dependencies = {
		"smjonas/snippet-converter.nvim",
	},
	config = function()
		require("i18n-menu").setup()
		vim.keymap.set("n", "<leader>ii", ":TranslateMenu<cr>")
		vim.keymap.set("n", "<leader>id", ":TranslateDefault<cr>")
	end,
}
