--
-- Git integration
--
return {
    {
        -- This will make Git Greater
        'tpope/vim-fugitive'
    },
    {
        -- In addition to Fugitive, this plugin
        -- indicates how lines changed visually
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup({
            signs = {
                add          = { text = '+' },
                change       = { text = '~' }
            },
            current_line_blame = false,
        }) end
    },
}
