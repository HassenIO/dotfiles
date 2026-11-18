--
-- Welcome screen: list the custom keymaps when starting without a file
--
local M = {}

---@param custom_keymaps { lhs: string, desc: string }[] keymaps returned by config/keymaps.lua
function M.setup(custom_keymaps)
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            if vim.fn.argc() > 0 or vim.api.nvim_buf_get_name(buf) ~= ""
                or vim.bo[buf].modified or vim.api.nvim_buf_line_count(buf) > 1 then
                return
            end

            local function label(lhs)
                local s = lhs:gsub("<leader>", vim.g.mapleader)
                s = s:gsub("<C%-S%-(.)>", "Ctrl-Shift-%1")
                s = s:gsub("<C%-(.)>", function(k) return "Ctrl-" .. k:upper() end)
                return s
            end

            local width = 0
            for _, km in ipairs(custom_keymaps) do
                width = math.max(width, #label(km.lhs))
            end

            local rows = {
                "Welcome Hassen",
                "",
                os.date("%A %d %B %Y, %H:%M"),
                vim.fn.fnamemodify(vim.fn.getcwd(), ":~"),
            }

            local branch = vim.fn.systemlist({ "git", "branch", "--show-current" })
            if vim.v.shell_error == 0 then
                local added, edited, deleted = 0, 0, 0
                for _, line in ipairs(vim.fn.systemlist({ "git", "status", "--porcelain", "--untracked-files=all" })) do
                    local code = line:sub(1, 2)
                    if code == "??" or code:find("A") then
                        added = added + 1
                    elseif code:find("D") then
                        deleted = deleted + 1
                    else
                        edited = edited + 1
                    end
                end
                table.insert(rows, string.format("Git branch %s: %d added, %d edited, %d deleted",
                    branch[1] ~= nil and branch[1] ~= "" and branch[1] or "(detached HEAD)", added, edited, deleted))
            end

            local separator = "\0separator" -- replaced by a line as wide as the block below
            vim.list_extend(rows, { "", separator, "", "Custom keymaps", "" })
            for _, km in ipairs(custom_keymaps) do
                table.insert(rows, label(km.lhs) .. string.rep(" ", width - #label(km.lhs) + 4) .. km.desc)
            end

            -- Center the block in the window
            local block = 0
            for _, row in ipairs(rows) do
                if row ~= separator then block = math.max(block, vim.fn.strdisplaywidth(row)) end
            end
            local indent = string.rep(" ", math.max(0, math.floor((vim.o.columns - block) / 2)))
            local lines = {}
            for _ = 1, math.max(0, math.floor((vim.o.lines - #rows) / 3)) do table.insert(lines, "") end
            for _, row in ipairs(rows) do
                if row == separator then row = string.rep("─", block) end
                table.insert(lines, row == "" and "" or indent .. row)
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].modifiable = false
            vim.bo[buf].modified = false
            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].swapfile = false
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.colorcolumn = ""
        end,
    })
end

return M
