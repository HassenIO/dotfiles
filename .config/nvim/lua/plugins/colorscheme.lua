--
-- Colorschemes
--
return {
    {
        -- This is the Github theme (active colorscheme)
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('github-theme').setup({
                -- ...
            })

            vim.cmd('colorscheme github_dark')
        end,
    },
    {
        -- This is the Theme Catppuccin
        -- example: vim.cmd.colorscheme "catppuccin-mocha"
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000
    },
}

-- Custom theme from lua/themes/
-- Ensure to set variables before loading the theme to apply
-- package.loaded['themes.accent'] = nil
-- vim.g.accent_color = 'yellow'
-- vim.g.status_line_color = 'black'
-- require('themes.accent').setup()
