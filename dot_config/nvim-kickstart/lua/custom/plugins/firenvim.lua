return {
  'glacambre/firenvim',
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn['firenvim#install'](0)
  end,

  -- cond = not not vim.g.started_by_firenvim,

  config = function()
    vim.g.firenvim_config = {
      localSettings = {
        ['.*'] = {
          cmdline = 'neovim',
          content = 'text',
          priority = 0,
          selector = 'textarea',
          takeover = 'always',
        },
      },
    }
    vim.api.nvim_set_keymap('n', '<C-q>', ':<C-u>call firenvim#focus_page()<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<C-q>', '<Esc>:<C-u>call firenvim#focus_page()<CR>', { noremap = true, silent = true })
  end,
}
