-- Set leader keys before loading plugins (CRITICAL)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core options, keymaps, and plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins.lazy")
