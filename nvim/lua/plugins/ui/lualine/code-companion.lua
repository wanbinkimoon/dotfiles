local CodeCompanionSpinner = require("lualine.component"):extend()

CodeCompanionSpinner.processing = false
CodeCompanionSpinner.spinner_index = 1
CodeCompanionSpinner.icons = require("config.icons")

local spinner_symbols = {
	"⠋",
	"⠙",
	"⠹",
	"⠸",
	"⠼",
	"⠴",
	"⠦",
	"⠧",
	"⠇",
	"⠏",
}
local spinner_symbols_len = 10

-- Initializer
function CodeCompanionSpinner:init(options)
	CodeCompanionSpinner.super.init(self, options)

	local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequest*",
		group = group,
		callback = function(request)
			if request.match == "CodeCompanionRequestStarted" then
				self.processing = true
			elseif request.match == "CodeCompanionRequestFinished" then
				self.processing = false
			end
		end,
	})
end

-- Function that runs every time statusline is updated
function CodeCompanionSpinner:update_status()
	if self.processing then
		self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
		return spinner_symbols[self.spinner_index] .. " " .. self.icons.misc.Robot .. " Code Companion"
	else
		return nil
	end
end

return CodeCompanionSpinner
