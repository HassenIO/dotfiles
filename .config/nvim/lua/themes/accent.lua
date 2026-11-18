-- accent.lua
--
-- a simple neovim colorscheme with a configurable accent colour.
-- by alligator (Lua conversion and modifications by Claude)
--
-- https://github.com/Alligator/accent.vim

local M = {}

-- Helper function to set highlights
local function highlight(group, color)
    local style = color.style and "gui=" .. color.style or "gui=NONE"
    local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
    local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
    local sp = color.sp and "guisp=" .. color.sp or ""

    vim.cmd("highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp)
end

function M.setup()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end
    vim.o.termguicolors = true
    vim.g.colors_name = "accent"

    local config = {
        accent_colours = {
            red     = { fg = '#e06c75', bg = '#b04c55', ctermfg = '167', ctermbg = '131' },
            orange  = { fg = '#ee9360', bg = '#b66930', ctermfg = '173', ctermbg = '166' },
            green   = { fg = '#98c379', bg = '#689349', ctermfg = '149', ctermbg = '107' },
            yellow  = { fg = '#e5c07b', bg = '#a5803b', ctermfg = '179', ctermbg = '136' },
            blue    = { fg = '#61afe7', bg = '#3876af', ctermfg = '74',  ctermbg = '67' },
            magenta = { fg = '#c688cd', bg = '#965498', ctermfg = '176', ctermbg = '133' },
            cyan    = { fg = '#56b6c2', bg = '#3696a2', ctermfg = '73',  ctermbg = '30' },
            black   = { fg = '#2e2e2e', bg = '#1e1e1e', ctermfg = '16', ctermbg = '235' }
        },
        accent_auto_cwd_colour = vim.g.accent_auto_cwd_colour or false,
        accent_colour = vim.g.accent_colour or vim.g.accent_color or 'yellow',
        accent_darken = vim.g.accent_darken or false,
        accent_invert_status = vim.g.accent_invert_status or false,
        accent_no_bg = vim.g.accent_no_bg or false,
        status_line_color = vim.g.status_line_color or 'blue'  -- New option for status line color
    }

    -- 32 bit fowler-noll-vo hash
    local function fnv1a(str)
        local hash = 2166136261
        for i = 1, #str do
            local c = str:byte(i)
            hash = bit.bxor(hash, c)
            hash = hash * 16777619
        end
        return hash
    end

    if config.accent_auto_cwd_colour then
        local hash = fnv1a(vim.fn.getcwd())
        local keys = vim.tbl_keys(config.accent_colours)
        local key_index = math.abs(hash) % #keys + 1
        config.accent_colour = keys[key_index]
    end

    -- Ensure accent_colour is valid
    if not config.accent_colours[config.accent_colour] then
        print("Warning: Invalid accent_colour. Falling back to yellow.")
        config.accent_colour = 'yellow'
    end

    -- Ensure status_line_color is valid
    if not config.accent_colours[config.status_line_color] then
        print("Warning: Invalid status_line_color. Falling back to blue.")
        config.status_line_color = 'blue'
    end

    local accent = config.accent_colours[config.accent_colour]
    local status_line = config.accent_colours[config.status_line_color]

    -- Define colors
    local colors = {
        fg      = { fg = '#bcbfc4' },
        fg_b1   = { fg = '#efefff' },
        fg_d1   = { fg = '#999999' },
        fg_d2   = { fg = '#777777' },
        fg_inv  = { fg = '#282c34' },
        fg_invd = { fg = '#181c24' },
        fg_c    = { fg = accent.fg },
        bg      = { bg = '#282c34' },
        bg_b1   = { bg = '#383c44' },
        bg_b2   = { bg = '#484c54' },
        bg_none = { bg = 'NONE' },
        bg_inv  = { bg = '#cccfd4' },
        bg_red  = { bg = config.accent_colours.red.bg },
        bg_c    = { bg = accent.bg },
        bg_status = { bg = status_line.bg }  -- New color for status line background
    }

    if config.accent_darken then
        colors.fg.fg    = '#acafb4'
        colors.fg_b1.fg = '#dfdfef'
        colors.fg_d1.fg = '#888888'
        colors.fg_d2.fg = '#666666'
        colors.bg.bg    = '#181c24'
    end

    -- Set highlights
    local highlights = {
        Normal = { fg = colors.fg.fg, bg = config.accent_no_bg and 'NONE' or colors.bg.bg },
        StatusLine = {
            fg = config.accent_invert_status and colors.fg_invd.fg or colors.fg_b1.fg,
            bg = colors.bg_status.bg  -- Use the new status line background color
        },
        StatusLineNC = { fg = colors.fg_d1.fg, bg = colors.bg_b2.bg },
        VertSplit = { fg = colors.fg_c.fg, bg = colors.bg_b1.bg },
        LineNr = { fg = colors.fg_d2.fg, bg = 'NONE' },
        CursorLineNr = { fg = colors.fg_b1.fg, bg = 'NONE' },
        CursorLine = { bg = colors.bg_b1.bg },
        MatchParen = { fg = colors.fg_b1.fg, bg = colors.bg_b1.bg, style = 'bold' },
        NonText = { fg = colors.fg_d2.fg, bg = 'NONE' },
        WildMenu = { fg = colors.fg_inv.fg, bg = colors.bg_inv.bg },
        Search = { fg = colors.fg_inv.fg, bg = colors.bg_c.bg },
        Folded = { fg = colors.fg_b1.fg, bg = colors.bg_b1.bg },
        Visual = { bg = colors.bg_b2.bg },
        Pmenu = { fg = colors.fg_d1.fg, bg = colors.bg_b1.bg },
        PmenuSel = { fg = colors.fg_c.fg, bg = colors.bg_b2.bg },
        TabLine = { fg = colors.fg_d1.fg, bg = colors.bg_b1.bg },
        TabLineFill = { fg = colors.fg_d1.fg, bg = colors.bg_b2.bg },
        Question = { fg = colors.fg_c.fg },
        SpellBad = { sp = config.accent_colours.red.fg, style = 'undercurl' },
        SpellRare = { sp = config.accent_colours.magenta.fg, style = 'undercurl' },
        SpellCap = { sp = config.accent_colours.blue.fg, style = 'undercurl' },
        SpellLocal = { sp = config.accent_colours.cyan.fg, style = 'undercurl' },
        Comment = { fg = colors.fg_d2.fg, bg = 'NONE' },
        String = { fg = colors.fg_c.fg, bg = 'NONE' },
        Type = { fg = colors.fg_b1.fg, bg = 'NONE' },
        PreProc = { fg = colors.fg_d1.fg, bg = 'NONE' },
        Underlined = { fg = colors.fg.fg, bg = 'NONE', style = 'underline' },
        Special = { fg = colors.fg_c.fg, bg = 'NONE' },
        Error = { fg = colors.fg_b1.fg, bg = colors.bg_red.bg },
        DiffAdd = { fg = config.accent_colours.green.fg, bg = 'NONE' },
        DiffDelete = { fg = config.accent_colours.red.fg, bg = 'NONE' },
        DiffChange = { bg = colors.bg_b1.bg },
        DiffText = { fg = colors.fg_b1.fg, bg = colors.bg_red.bg }
    }

    -- Apply highlights
    for group, color in pairs(highlights) do
        highlight(group, color)
    end

    -- Link highlights
    local links = {
        ['StatusLineTerm'] = 'StatusLine',
        ['StatusLineTermNC'] = 'StatusLineNC',
        ['MoreMsg'] = 'Question',
        ['FoldColumn'] = 'Folded',
        ['Operator'] = 'Normal',
        ['Identifier'] = 'Normal',
        ['Todo'] = 'Normal',
        ['Macro'] = 'PreProc',
        ['Statement'] = 'Type',
        ['Constant'] = 'Type',
        ['SpecialKey'] = 'Comment',
        ['Title'] = 'Type',
        ['Directory'] = 'Type',
        ['Function'] = 'Type',
        ['Number'] = 'String',
        ['Character'] = 'String',
        ['ErrorMsg'] = 'Error',
        ['xmlAttrib'] = 'Normal',
        ['sqlKeyword'] = 'Type',
        ['diffAdded'] = 'DiffAdd',
        ['diffRemoved'] = 'DiffDelete'
    }

    for from, to in pairs(links) do
        vim.cmd('hi! link ' .. from .. ' ' .. to)
    end
end

return M
