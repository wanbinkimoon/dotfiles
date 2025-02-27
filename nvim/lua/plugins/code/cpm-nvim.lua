return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"mattn/emmet-vim",
		"dcampos/cmp-emmet-vim",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"hrsh7th/cmp-nvim-lsp",
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
		"tailwind-tools",
	},
	config = function()
		local cmp = require("cmp")
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				-- Copilot Source
				{ name = "copilot", group_index = 2 },
				-- Other Sources
				{ name = "path", group_index = 2 },
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
				{ name = "emmet_vim" },
			}),
		})
	end,
}
