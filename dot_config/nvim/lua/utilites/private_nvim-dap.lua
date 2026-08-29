return {
  'mfussenegger/nvim-dap',

  dependencies = {
    'mfussenegger/nvim-dap-python',
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local dap_python = require('dap-python')

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    dap.adapters.lldb = {
      type = 'executable',
      command = '/usr/bin/lldb-dap',
      name = 'lldb',
    }

    dap.configurations.rust = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',

        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,

        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    dap_python.setup('uv')

    vim.keymap.set('n', '<leader>db', function()
      dap.toggle_breakpoint()
    end, {
      desc = 'DAP: Toggle breakpoint',
    })

    vim.keymap.set('n', '<F5>', function()
      dap.continue()
    end, {
      desc = 'DAP: Continue',
    })

    vim.keymap.set('n', '<F10>', function()
      dap.step_over()
    end, {
      desc = 'DAP: Step over',
    })

    vim.keymap.set('n', '<F11>', function()
      dap.step_into()
    end, {
      desc = 'DAP: Step into',
    })

    vim.keymap.set('n', '<S-F11>', function()
      dap.step_out()
    end, {
      desc = 'DAP: Step out',
    })

    vim.keymap.set('n', '<F9>', function()
      dap.terminate()
    end, {
      desc = 'DAP: Terminate',
    })
  end,
}
