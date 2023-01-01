vim.g.mapleader = " "

vim.keymap.set("n", "<C-N>", ":NnnPicker<CR>")

vim.keymap.set("n", "<C-?>", vim.diagnostic.open_float) -- Open LSP diagnostic "gl"
