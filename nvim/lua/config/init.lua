require("config.autoreload").setup()
require("config.buffer-management").setup()

require("config.keymaps")
require("config.lsp")
require("config.tmux")
require("config.vim")

-- Should be loaded after all other configs
require("config.lazy")
