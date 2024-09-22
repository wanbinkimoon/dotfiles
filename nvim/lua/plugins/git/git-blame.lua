return {
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = " <author> • <date> • <summary> • <sha>",
			date_format = "%d/%m/%y %H:%M:%S",
			virtual_text_column = 1,
		},
	},
}
