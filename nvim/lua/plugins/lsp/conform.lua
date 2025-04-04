return {
	"stevearc/conform.nvim",
	lazy = true,
	event = "BufRead",
	opts = {},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", "eslint_d", stop_after_first = false },
				typescript = { "prettierd", "prettier", "eslint_d", stop_after_first = false },
				typescriptreact = { "prettierd", "prettier", "eslint_d", stop_after_first = false },
				javascriptreact = { "prettierd", "prettier", "eslint_d", stop_after_first = false },
				yaml = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				handlebars = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 10 * 1000,
				timeout = 10 * 1000,
				async = true,
			},
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
		})

		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
	end,
}
