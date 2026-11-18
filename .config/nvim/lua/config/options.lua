--
-- Editor options
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

-- True colors (must be set before the colorscheme loads)
vim.o.termguicolors = true

-- Treat MDX as Markdown (Neovim has no mdx filetype)
vim.filetype.add({ extension = { mdx = "markdown" } })

-- Disable intro message
vim.opt.shortmess:append("I")

-- Disable ins-completion-menu messages
vim.opt.shortmess:append("c")

-- Show cursor line and column in the status line
vim.o.ruler = true

-- When scrolling, keep cursor 8 lines away from screen border
vim.o.scrolloff = 8

-- Timeout on leaderkey
vim.o.ttimeout = true
vim.o.ttimeoutlen = 5

-- Right column max chars and color
vim.cmd [[
highlight ColorColumn ctermbg=darkgray guibg=#3c3c3c
set colorcolumn=120
]]

-- Exclude files and directories using Vim's wildignore
vim.o.wildignore = vim.o.wildignore .. "*/tmp/*,*.so,*.swp,*.zip" -- MacOSX/Linux

-- Set directories for swap/backup/undo files and create them if necessary
local function cache_dir(name)
    local dir = vim.fn.expand("~/.cache/nvim/" .. name .. "/")
    vim.fn.mkdir(dir, "p")
    return dir
end
vim.o.directory = cache_dir("swap")
vim.o.backupdir = cache_dir("backup")
vim.o.undodir = cache_dir("undo")

-- Disable some builtin vim plugins
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
