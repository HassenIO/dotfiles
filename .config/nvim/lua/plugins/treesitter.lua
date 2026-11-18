--
-- Syntax highlighting and parsing
--
return {
    {
        -- Treesitter is necessary for Telescope
        -- The `main` branch needs the tree-sitter CLI (brew install tree-sitter-cli)
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').install({
                "bash",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "ruby",
                "query",
                "regex",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            })

            -- The `main` branch no longer enables highlighting by itself
            vim.api.nvim_create_autocmd('FileType', {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
