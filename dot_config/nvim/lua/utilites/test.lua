return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-python'),
        },
      })
      vim.keymap.set('n', '<leader>tn', function()
        require('neotest').run.run()
      end, { desc = 'Run nearest test' })

      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand('%'))
      end, { desc = 'Run test file' })

      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle test summary' })

      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open({ enter = true })
      end, { desc = 'Show test output' })
    end,
  },
}
