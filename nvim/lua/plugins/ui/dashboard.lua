return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local dashboard = require("alpha.themes.dashboard")
		local icons = require("config.icons")

		-- Set header
		dashboard.section.header.val = {
			"                                                     ",
			"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			"                                                     ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("f", " Find file", ":Telescope find_files <CR>"),
			dashboard.button("n", " New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("r", " Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("t", " Find text", ":Telescope live_grep <CR>"),
			dashboard.button("c", " Config", ":e $MYVIMRC <CR>"),
			dashboard.button("q", " Quit", ":qa<CR>"),
		}

		-- Set footer
		local function footer()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
		end

		dashboard.section.footer.val = footer()

		-- Send config to alpha
		require("alpha").setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
