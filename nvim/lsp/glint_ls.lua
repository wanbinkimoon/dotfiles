return {
	cmd = function(dispatchers, config)
		local cmd = (config.init_options.glint.useGlobal or not config.root_dir) and { "glint-language-server" }
			or { config.root_dir .. "/node_modules/.bin/glint-language-server" }
		return vim.lsp.rpc.start(cmd, dispatchers)
	end,
	init_options = {
		glint = {
			useGlobal = false,
		},
	},
	filetypes = {
		"html.handlebars",
		"handlebars",
		"typescript",
		"typescript.glimmer",
		"javascript",
		"javascript.glimmer",
	},
	root_markers = {
		".glintrc.yml",
		".glintrc",
		".glintrc.json",
		".glintrc.js",
		"glint.config.js",
		"package.json",
	},
	workspace_required = true,
}
