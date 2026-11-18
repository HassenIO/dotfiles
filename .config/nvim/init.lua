--
-- Prepare Lazy VIM
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Map leader (must be set before Lazy so plugin mappings use it)
vim.g.mapleader = ';'

--
-- Install plugins with Lazy VIM
--
require("lazy").setup({
    {
        -- This will boost startup time
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    }, {
        -- This has a bunch of methods that will be useful for NeoVIM
        'nvim-lua/plenary.nvim'
    }, {
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
    }, {
        -- Telescope is used to navigate through the project
        'nvim-telescope/telescope.nvim',
        tag = 'v0.2.2',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    }, {
        -- This is the Github theme
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
    }, {
        -- This is the Theme Catppuccin
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000
    }, {
        -- Use NNN as file navigator
        'luukvbaal/nnn.nvim',
        config = function() require('nnn').setup() end
    }, {
        -- This will make Git Greater
        'tpope/vim-fugitive'
    }, {
        -- In addition to Figitive, this plugins
        -- indicates how lines changed visually
        'lewis6991/gitsigns.nvim',
        config = function() require('gitsigns').setup({
            signs = {
                add          = { text = '+' },
                change       = { text = '~' }
            },
            current_line_blame = false,
        }) end
    }, {
        -- Lightweight lua status line
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    }, {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- Add any opts here
            -- Source: https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
            provider = "claude", -- Recommend using Claude
            auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
            providers = {
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-5-5",
                    extra_request_body = {
                        temperature = 0,
                        max_tokens = 4096,
                    },
                },
            },
            behaviour = {
                auto_suggestions = true, -- Experimental stage
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }, {
        -- Is used to run tests without leaving the editor
        'vim-test/vim-test'
    }, {
        -- Using Hop to jump to a word, but maybe better use easymotion
        -- Maintained fork of the archived phaazon/hop.nvim
        'smoka7/hop.nvim',
        version = '*',
        config = function() require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' } end
    }, {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    }
}, {
    -- No plugin needs luarocks; this silences the hererocks health errors
    rocks = { enabled = false },
})

--
-- Explicitly starting some plugins
--

-- Lua line
require('lualine').setup()

-- Custom theme from lua/themes/
-- Ensure to set variables before loading the theme to apply
-- package.loaded['themes.accent'] = nil
-- vim.g.accent_color = 'yellow'
-- vim.g.status_line_color = 'black'
-- require('themes.accent').setup()

--
-- My VIM configs
--

-- Fonts
-- vim.o.guifont = "JetBrains Mono:h24"
vim.o.guifont = "Cascadia Code:h24"

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Take indent for new line from previous line
vim.o.autoindent = true -- Same indent as previous line
vim.o.smartindent = true -- Smart insertion of indent in some cases
vim.o.expandtab = true -- Replace <Tab> by spaces
vim.o.softtabstop = 4 -- How many spaces is a <Tab>
vim.o.shiftwidth = 4 -- How many spaces for the >> operation

-- Enable highlight on search
vim.o.hlsearch = true
-- highlight match while typing search pattern
vim.o.incsearch = true

-- Enable break indent
vim.o.breakindent = true

-- Use swapfiles
vim.o.swapfile = true

-- Save undo history
vim.o.undofile = true
vim.o.undolevels = 1000

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme (order is important here)
-- example: vim.cmd.colorscheme "catppuccin-mocha"
vim.o.termguicolors = true

-- Disable intro message
vim.opt.shortmess:append("I")

-- Disable ins-completion-menu messages
vim.opt.shortmess:append("c")

-- Show cursor line and column in the status line
vim.o.ruler = true

-- When scrolling, keep cursor 4 lines away from screen border
vim.o.scrolloff = 8

-- Timeout on leaderkey
vim.o.ttimeout = true
vim.o.ttimeoutlen = 5

-- Right column max chars and color
vim.cmd [[
highlight ColorColumn ctermbg=darkgray guibg=#3c3c3c
set colorcolumn=120
]]

-- Highlight on yank
-- When doing yank, the yanked text will brifly be highlighted
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- Open file at same location where it was opened last time
vim.cmd(
[[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
)

-- Exclude files and directories using Vim's wildignore
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip" -- MacOSX/Linux

-- Set directories for backup/swap/undo files and create them if necessary
local Path = require("plenary.path")

local swapdir = Path:new(Path.path.home .. "/.cache/nvim/swap/")
if not swapdir:exists() then
    swapdir:mkdir()
end
vim.o.directory = tostring(swapdir)

local backupdir = Path:new(Path.path.home .. "/.cache/nvim/backup/")
if not backupdir:exists() then
    backupdir:mkdir()
end
vim.o.backupdir = tostring(backupdir)

local undodir = Path:new(Path.path.home .. "/.cache/nvim/undo/")
if not undodir:exists() then
    undodir:mkdir()
end
vim.o.undodir = tostring(undodir)

-- disable some builtin vim plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

--
-- My custom Keymaps
--
vim.keymap.set("n", "=-", "gg=G", { silent = true, desc = "Re-indent the whole file" })

--
-- Keymaps to use plugins
--
vim.keymap.set("n", "<C-N>", ":NnnPicker %:p:h<CR>", { desc = "nnn: pick a file in this file's folder" })
vim.keymap.set("n", "<C-P>", ":Telescope find_files<CR>", { desc = "Telescope: find files" })
vim.keymap.set("n", "<C-B>", ":Telescope buffers<CR>", { desc = "Telescope: open buffers" })
vim.keymap.set("n", "<C-/>", ":Telescope live_grep<CR>", { desc = "Telescope: live grep" })
vim.keymap.set("n", "<C-_>", ":Telescope live_grep<CR>", { desc = "Telescope: live grep" }) -- what most terminals send for Ctrl-/
vim.keymap.set("n", "<C-G>", ":Telescope git_status<CR>", { desc = "Telescope: git status" })
vim.keymap.set("n", "<C-S-D>", ":Gdiffsplit<CR>", { desc = "Fugitive: diff against git" })
vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", { desc = "Test: run nearest test" })
vim.keymap.set("n", "<leader>T", ":TestFile<CR>", { desc = "Test: run current file" })
vim.keymap.set("n", "<leader>r", ":!rubocop -A --no-color %<CR>", { desc = "Rubocop: fix current file" })
vim.keymap.set("n", "<leader>R", ":!rubocop -A --no-color .<CR>", { desc = "Rubocop: fix whole project" })
vim.keymap.set("n", "<C-s>", ":HopPattern<CR>", { desc = "Hop: jump to a pattern" })
vim.keymap.set("n", "<leader>;", ":Telescope keymaps<CR>", { desc = "Telescope: search keymaps" })

