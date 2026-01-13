require('lze').load {
  {
    "nvim-dap",
    for_cat = { cat = 'debug', default = false }, keys = {
      { "<leader>dd", desc = "Debug: Start/Continue" },
      { "<leader>di", desc = "Debug: Step Into" },
      { "<leader>dn", desc = "Debug: Step Over" },
      { "<leader>doo", desc = "Debug: Step Out" },
      { "<leader>b", desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", desc = "Debug: Set Breakpoint" },
      { "<leader>ld", desc = "Debug: See last session result." },
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
    after = function (plugin)
      local dap = require 'dap'
      local dapui = require 'dapui'

      vim.keymap.set('n', '<leader>xd', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      vim.keymap.set('n', '<leader>ld', dapui.toggle, { desc = 'Debug: See last session result.' })

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

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
                        require("dap-python").setup("python")
                end,
        },
}
