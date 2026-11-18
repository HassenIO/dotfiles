# Neovim configuration

A Lua Neovim setup built on [lazy.nvim](https://github.com/folke/lazy.nvim). It covers Telescope navigation, Git integration, Treesitter highlighting, running tests and an AI assistant (Avante + Claude). Starting Neovim without a file opens a welcome screen that lists the custom keymaps.

## Requirements

| Tool | Why |
| --- | --- |
| Neovim ≥ 0.11 | Uses `vim.uv`, `vim.hl` and the Treesitter `main` branch |
| `git` | Bootstraps lazy.nvim and installs plugins |
| `tree-sitter` CLI | Needed by nvim-treesitter's `main` branch (`brew install tree-sitter-cli`) |
| `make` + a C compiler | Builds avante.nvim |
| [`nnn`](https://github.com/jarun/nnn) | File picker behind `Ctrl-N` |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) | Telescope live grep |
| A Nerd Font (e.g. Cascadia Code) | Icons in lualine / devicons |
| `ANTHROPIC_API_KEY` env var | Avante's Claude provider |
| `rubocop` (optional) | `<leader>r` / `<leader>R` |

## Installation

```sh
git clone <this repo> ~/.config/nvim
nvim   # lazy.nvim installs itself and every plugin on first launch
```

Plugin versions are pinned in `lazy-lock.json`. Use `:Lazy sync` to update them and `:Lazy restore` to go back to the locked versions.

## Layout

```
~/.config/nvim
├── init.lua               Entry point: sets the leader and loads the modules below
├── lazy-lock.json         Pinned plugin versions (managed by lazy.nvim)
├── AGENTS.md              Instructions for AI coding agents
├── CLAUDE.md              Points Claude Code at AGENTS.md
└── lua/
    ├── config/
    │   ├── options.lua    Editor options, cache dirs, disabled built-in plugins
    │   ├── lazy.lua       Bootstraps lazy.nvim and imports lua/plugins/
    │   ├── autocmds.lua   Yank highlight, restore last cursor position
    │   ├── keymaps.lua    Custom keymaps (returned as a list for the welcome screen)
    │   └── welcome.lua    Start screen shown when Neovim opens without a file
    ├── plugins/           One file per topic; each returns lazy.nvim specs
    │   ├── colorscheme.lua  github-nvim-theme (active), catppuccin
    │   ├── treesitter.lua   nvim-treesitter + parser list
    │   ├── navigation.lua   plenary, telescope, nnn, hop
    │   ├── git.lua          vim-fugitive, gitsigns
    │   ├── ui.lua           lualine, noice
    │   ├── tools.lua        vim-startuptime, vim-test
    │   └── ai.lua           avante.nvim (Claude) and its dependencies
    └── themes/
        └── accent.lua     Custom colorscheme with a configurable accent colour (off by default)
```

### Load order

`init.lua` loads the modules in this order:

1. `vim.g.mapleader = ';'`, which has to be set before any plugin defines mappings.
2. `config.options`, so options such as `termguicolors` and the disabled built-ins are in place before plugins load.
3. `config.lazy`, which installs and loads the plugins.
4. `config.autocmds`
5. `config.keymaps`, whose list of keymaps is passed to `config.welcome`.

## Plugins

| Plugin | Purpose |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) | Active colorscheme (`github_dark`) |
| [catppuccin](https://github.com/catppuccin/nvim) | Alternative colorscheme |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting (`main` branch) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, buffers, grep and git status |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library used by other plugins |
| [nnn.nvim](https://github.com/luukvbaal/nnn.nvim) | nnn file manager inside Neovim |
| [hop.nvim](https://github.com/smoka7/hop.nvim) | Jump to any pattern on screen |
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git change markers in the sign column |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [noice.nvim](https://github.com/folke/noice.nvim) | Replaces the UI for messages, the cmdline and popups |
| [vim-test](https://github.com/vim-test/vim-test) | Runs tests from the editor |
| [vim-startuptime](https://github.com/dstein64/vim-startuptime) | `:StartupTime` profiling |
| [avante.nvim](https://github.com/yetone/avante.nvim) | AI assistant using Claude (`claude-sonnet-5-5`) |

## Keymaps

Leader is `;`.

| Keys | Action |
| --- | --- |
| `=-` | Re-indent the whole file |
| `Ctrl-N` | nnn: pick a file in the current file's folder |
| `Ctrl-P` | Telescope: find files |
| `Ctrl-B` | Telescope: open buffers |
| `Ctrl-/` | Telescope: live grep |
| `Ctrl-G` | Telescope: git status |
| `Ctrl-Shift-D` | Fugitive: diff against git (`:Gdiffsplit`) |
| `Ctrl-S` | Hop: jump to a pattern |
| `;t` | Run nearest test |
| `;T` | Run current test file |
| `;r` | Rubocop autocorrect the current file |
| `;R` | Rubocop autocorrect the whole project |
| `;;` | Telescope: search all keymaps |

Avante sets up its own keymaps (`auto_set_keymaps = true`). See the [avante.nvim docs](https://github.com/yetone/avante.nvim#key-bindings).

## Editor behaviour

- Line numbers are relative and absolute at the same time. Indentation uses 4 spaces, and there is a ruler at column 120.
- Search ignores case unless the pattern contains a capital letter.
- Swap, backup and undo files are kept in `~/.cache/nvim/{swap,backup,undo}`, and undo history persists between sessions.
- Yanked text is briefly highlighted.
- When you reopen a file, the cursor goes back to where you left it. Files inside `.git/` are excluded.
- `.mdx` files are treated as Markdown.
- netrw, matchit, gzip/tar/zip and other unused built-in plugins are disabled.

## Customising

**Add a plugin:** create a new file in `lua/plugins/` (or add to an existing one) that returns a lazy.nvim spec table. lazy.nvim imports it automatically.

```lua
-- lua/plugins/example.lua
return {
    { "author/plugin.nvim", opts = {} },
}
```

**Add a keymap:** use the `map(lhs, rhs, desc)` helper in `lua/config/keymaps.lua`. Keymaps added this way show up on the welcome screen.

**Change the colorscheme:** edit the `config` function of `github-theme` in `lua/plugins/colorscheme.lua`, e.g. `vim.cmd.colorscheme("catppuccin-mocha")`.

**Use the accent theme:** uncomment the block at the bottom of `lua/plugins/colorscheme.lua`. Set `vim.g.accent_color` (red, orange, green, yellow, blue, magenta, cyan or black) before calling `require('themes.accent').setup()`.

**Add a Treesitter parser:** add it to the list in `lua/plugins/treesitter.lua`.

## Useful commands

| Command | What it does |
| --- | --- |
| `:Lazy` | Plugin manager UI |
| `:checkhealth` | Diagnose the setup |
| `:StartupTime` | Profile startup |
| `:TSUpdate` | Update Treesitter parsers |
| `:Telescope keymaps` | Browse every mapping |
