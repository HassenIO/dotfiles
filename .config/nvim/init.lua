-- Neovim configuration entry point.
-- See README.md for an overview of the layout.

-- Map leader (must be set before Lazy so plugin mappings use it)
vim.g.mapleader = ';'

require("config.options")
require("config.lazy")
require("config.autocmds")
require("config.welcome").setup(require("config.keymaps"))
