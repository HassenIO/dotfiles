# Agent instructions

This is a personal Neovim config written in Lua and managed by lazy.nvim. `README.md` describes the layout, plugins and keymaps for humans. This file covers what an agent needs to know before changing anything.

## Where things go

| Change | File |
| --- | --- |
| Editor option (`vim.o`, `vim.opt`, `vim.g`) | `lua/config/options.lua` |
| Autocommand | `lua/config/autocmds.lua` |
| Keymap | `lua/config/keymaps.lua`, using the `map(lhs, rhs, desc, opts)` helper |
| New plugin | A file in `lua/plugins/` that returns a list of lazy.nvim specs (pick the topic file that fits, or create one) |
| Plugin options | The plugin's own spec, in `opts` or `config` |
| Treesitter parser | The list in `lua/plugins/treesitter.lua` |
| Welcome screen | `lua/config/welcome.lua` |

Keep `init.lua` minimal. It only sets the leader and requires the `config.*` modules.

## Rules

- **Load order matters.** `mapleader` is set first, then options, then `config.lazy`, then autocmds, keymaps and the welcome screen. Anything a plugin reads at load time belongs in `options.lua`, which runs before lazy.nvim. Examples are `termguicolors` and the `vim.g.loaded_*` flags that disable built-in plugins.
- **Don't `require` a plugin from `lua/config/`.** Plugin setup goes in the plugin's spec. `options.lua` in particular runs before plugins are on the runtimepath.
- **Use `map()` for user-facing keymaps.** It sets `desc` and records the keymap so it shows on the welcome screen. Plain `vim.keymap.set` is only for aliases that shouldn't be listed (like `<C-_>`). Leader is `;`.
- **Update `README.md`** whenever you add or remove a plugin or keymap, or change the layout.
- **Don't edit `lazy-lock.json` by hand.** lazy.nvim manages it.
- **Match the existing style:** 4-space indent, a short `--` comment above each spec saying why the plugin is there, and a header comment at the top of each file.
- Use current Neovim APIs (`vim.uv`, `vim.hl`, `vim.api.nvim_create_autocmd`), not their deprecated equivalents.
- nvim-treesitter is on the `main` branch, which has a different API from `master`. It uses `require('nvim-treesitter').install`, and highlighting is started by a `FileType` autocmd.

## Verifying a change

There is no test suite. After editing, check that Neovim starts without errors:

```sh
nvim --headless "+lua print(require('lazy').stats().count, vim.g.colors_name)" +qa
```

The command should print the plugin count and `github_dark`, with no errors. For deeper checks:

```sh
nvim --headless "+checkhealth lazy" "+w! /tmp/health.txt" +qa && grep -iE "error|warn" /tmp/health.txt
```

To check the welcome screen, start `nvim` with no arguments from any directory.

## Git: this folder is part of a bare dotfiles repo

`~/.config/nvim` has no `.git` folder of its own. It is tracked by the bare repo `~/.dotfiles`, whose work tree is `$HOME`. The remote is `git@github.com:HassenIO/dotfiles.git` and the branch is `main`.

- **Never run `git init` here**, and don't use plain `git`, which will report "not a git repository".
- Run git through the `git dotfiles` alias from `~`. It is defined in `~/.gitconfig` as `!git --git-dir=$HOME/.dotfiles --work-tree=$HOME`.
- The repo hides untracked files, so new files don't show up in `status`. Add each file by explicit path. Never use `git dotfiles add -A` or `add .`, because either would stage the whole home directory. Leave out `.DS_Store`.
- Commit straight to `main`. Write short, imperative messages that mention "NeoVIM", e.g. `Open MDX files as Markdown in NeoVIM`.

```sh
cd ~
git dotfiles status --short -- .config/nvim     # tracked changes only
git dotfiles ls-files .config/nvim              # what is tracked
git dotfiles add .config/nvim/init.lua .config/nvim/lua/plugins/new.lua
git dotfiles commit -m "Add <thing> to NeoVIM"
git dotfiles push origin main
```
