-- lua/plugins/dap.lua などの別ファイル
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui', -- デバッグ画面を綺麗にするUI
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'
    dapui.setup()
    -- デバッグ開始時に自動でUIを開く
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
  end,
}
