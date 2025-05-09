return {
	"goolord/alpha-nvim",
	enabled = true,
	event = "VimEnter",
	lazy = true,
	config = function()
		local dashboard = require("alpha.themes.dashboard")

		local icons = require("config.icons")

		-- Set header
		-- dashboard.section.header.val = {
		-- 	"                                                     ",
		-- 	"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
		-- 	"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
		-- 	"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
		-- 	"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
		-- 	"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
		-- 	"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
		-- 	"                                                     ",
		-- }

		dashboard.section.header.val = {
			"   ",
			"   ",
			-- "███",
			"   ",
			"   ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("f", icons.ui.Search .. " Find file", ":Telescope find_files<CR>"),
			dashboard.button("d", icons.documents.Files .. " Search diff", ":Telescope git_branch<CR>"),
			dashboard.button("r", icons.ui.History .. " Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("t", icons.ui.Note .. " Find text", ":Telescope live_grep <CR>"),
			dashboard.button("q", icons.ui.Close .. " Quit", ":qa<CR>"),
		}

		-- Set footer
		local function footer()
			local stats = require("lazy").stats()

			return "⚡ Neovim loaded "
				.. stats.loaded
				.. "/"
				.. stats.count
				.. " plugins in "
				.. stats.times.LazyDone
				.. "ms"
		end

		dashboard.section.footer.val = footer()

		-- Send config to alpha
		require("alpha").setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
