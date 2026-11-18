--
-- Autocommands
--

-- Highlight on yank
-- When doing yank, the yanked text will briefly be highlighted
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- Open file at same location where it was opened last time
vim.cmd(
[[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
)
