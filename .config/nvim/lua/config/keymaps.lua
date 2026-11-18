--
-- Custom keymaps
--
-- Keymaps defined with `map` are recorded and returned, so the welcome
-- screen (config/welcome.lua) can list them.
--
local custom_keymaps = {}
local function map(lhs, rhs, desc, opts)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {}))
    table.insert(custom_keymaps, { lhs = lhs, desc = desc })
end

-- Editing
map("=-", "gg=G", "Re-indent the whole file", { silent = true })

-- Plugins
map("<C-N>", ":NnnPicker %:p:h<CR>", "nnn: pick a file in this file's folder")
map("<C-P>", ":Telescope find_files<CR>", "Telescope: find files")
map("<C-B>", ":Telescope buffers<CR>", "Telescope: open buffers")
map("<C-/>", ":Telescope live_grep<CR>", "Telescope: live grep")
vim.keymap.set("n", "<C-_>", ":Telescope live_grep<CR>", { desc = "Telescope: live grep" }) -- what most terminals send for Ctrl-/
map("<C-G>", ":Telescope git_status<CR>", "Telescope: git status")
map("<C-S-D>", ":Gdiffsplit<CR>", "Fugitive: diff against git")
map("<leader>t", ":TestNearest<CR>", "Test: run nearest test")
map("<leader>T", ":TestFile<CR>", "Test: run current file")
map("<leader>r", ":!rubocop -A --no-color %<CR>", "Rubocop: fix current file")
map("<leader>R", ":!rubocop -A --no-color .<CR>", "Rubocop: fix whole project")
map("<C-s>", ":HopPattern<CR>", "Hop: jump to a pattern")
map("<leader>;", ":Telescope keymaps<CR>", "Telescope: search keymaps")

return custom_keymaps
