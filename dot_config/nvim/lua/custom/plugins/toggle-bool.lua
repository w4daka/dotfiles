return {
  'w4daka/toggle-bool.vim',
  dependencies = { 'vim-denops/denops.vim' },
  config = function()
    vim.keymap.set('n', '<M-t>', function()
      vim.fn['denops#request']('toggle-bool', 'toggle', {})
    end, { desc = 'Toggle Boolean' })
  end,
}
