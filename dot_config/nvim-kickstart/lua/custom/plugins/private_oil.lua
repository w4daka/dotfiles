return {
  'stevearc/oil.nvim',
  opts = {
    keymaps = {
      ['g?'] = 'show_help',
      ['<CR>'] = 'actions.select',
      -- mini.files風の操作
      ['l'] = 'actions.select',
      ['h'] = 'actions.parent',
      ['q'] = 'actions.close',
      -- プレビュー
      ['<C-p>'] = 'actions.preview',
      -- リフレッシュ
      ['<C-l>'] = 'actions.refresh',
    },
    view_options = {
      show_hidden = true,
    },
  },
  config = function(_, opts)
    require('oil').setup(opts)

    vim.keymap.set('n', '<leader>e', function()
      -- 現在のファイルのディレクトリでOilを開く (mini.filesの挙動に合わせる)
      require('oil').open()
    end, { desc = 'Open oil (Directory of current file)' })
  end,
}
