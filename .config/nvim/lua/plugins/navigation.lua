--
-- Finding files and moving around
--
return {
    {
        -- This has a bunch of methods that will be useful for NeoVIM
        'nvim-lua/plenary.nvim'
    },
    {
        -- Telescope is used to navigate through the project
        'nvim-telescope/telescope.nvim',
        tag = 'v0.2.2',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
        -- Use NNN as file navigator
        'luukvbaal/nnn.nvim',
        config = function() require('nnn').setup() end
    },
    {
        -- Using Hop to jump to a word, but maybe better use easymotion
        -- Maintained fork of the archived phaazon/hop.nvim
        'smoka7/hop.nvim',
        version = '*',
        config = function() require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' } end
    },
}
