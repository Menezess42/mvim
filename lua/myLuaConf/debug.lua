require('lze').load {
    {
        "nvim-dap",
        for_cat = { cat = 'debug', default = false }, keys = {
        { "<leader>dd", desc = "Debug: Start/Continue" },
        { "<leader>i",  desc = "Debug: Step Into" },
        { "<leader>n",  desc = "Debug: Step Over" },
        { "<leader>o",  desc = "Debug: Step Out" },
        { "<leader>b",  desc = "Debug: Toggle Breakpoint" },
        { "<leader>B",  desc = "Debug: Set Breakpoint" },
        { "<leader>dl", desc = "Debug: See last session result." },
        { "<leader>dw", desc = "Debug: Add Watch expression." },
    },
        load = (require('nixCatsUtils').isNixCats and function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd("nvim-dap-ui")
            vim.cmd.packadd("nvim-dap-virtual-text")
        end) or function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd("nvim-dap-ui")
            vim.cmd.packadd("nvim-dap-virtual-text")
            vim.cmd.packadd("mason-nvim-dap.nvim")
        end,
        after = function(plugin)
            local dap = require 'dap'
            local dapui = require 'dapui'
            vim.keymap.set('n', '<leader>dd', dap.continue, { desc = 'Debug: Start/Continue' })
            vim.keymap.set('n', '<leader>i', dap.step_into, { desc = 'Debug: Step Into' })
            vim.keymap.set('n', '<leader>n', dap.step_over, { desc = 'Debug: Step Over' })
            vim.keymap.set('n', '<leader>o', dap.step_out, { desc = 'Debug: Step Out' })
            vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
            vim.keymap.set('n', '<leader>B', function()
                dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end, { desc = 'Debug: Set Breakpoint' })

            vim.keymap.set('n', '<leader>dl', dapui.toggle, { desc = 'Debug: See last session result.' })

            vim.keymap.set('n', '<leader>dw', function()
                require('dapui').elements.watches.add()
            end, { desc = 'Debug: Add watch expression' })

            dap.listeners.after.event_initialized['dapui_config'] = dapui.open

            dapui.setup {
                icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
                controls = {
                    icons = {
                        pause = '⏸',
                        play = '▶',
                        step_into = '⏎',
                        step_over = '⏭',
                        step_out = '⏮',
                        step_back = 'b',
                        run_last = '▶▶',
                        terminate = '⏹',
                        disconnect = '⏏',
                    },
                },
            }

            require("nvim-dap-virtual-text").setup {
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                clear_on_continue = false,
                display_callback = function(variable, buf, stackframe, node, options)
                    if options.virt_text_pos == 'inline' then
                        return ' = ' .. variable.value
                    else
                        return variable.name .. ' = ' .. variable.value
                    end
                end,
                virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

                all_frames = false,
                virt_lines = false,
                virt_text_win_col = nil
            }
        end,
    },
    {
        "nvim-dap-go",
        for_cat = { cat = 'debug.go', default = false },
        on_plugin = { "nvim-dap", },
        after = function(plugin)
            require("dap-go").setup()
        end,
    },
    {
        "nvim-dap-python",
        for_cat = { cat = 'debug.python', default = false },
        on_plugin = { "nvim-dap", },
        after = function(plugin)
            require("dap-python").setup()

            local dap = require("dap")

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Debug current file (project root)",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    pythonPath = function()
                        return vim.fn.exepath("python")
                    end,
                    env = {
                        PYTHONPATH = vim.fn.getcwd(),
                    },
                },
            }
        end,
    },
}
