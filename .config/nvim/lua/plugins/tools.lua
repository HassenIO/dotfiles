--
-- Development tools
--
return {
    {
        -- Measure startup time with :StartupTime
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
    {
        -- Is used to run tests without leaving the editor
        'vim-test/vim-test'
    },
}
