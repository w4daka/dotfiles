return {
  'kassio/neoterm',
  event = 'VeryLazy',
  init = function()
    -- プラグインが読み込まれる前に設定が必要な変数はここ
    vim.g.neoterm_default_mod = 'belowright' -- 下に開く
    vim.g.neoterm_size = 15 -- サイズ
    vim.g.neoterm_autoscroll = 1 -- 自動スクロール
  end,
  keys = {
    { '<leader>tg', '<cmd>Ttoggle<cr>', desc = 'Toggle Terminal' },
    { '<leader>tc', '<cmd>Tclear<cr>', desc = 'Clear Terminal' },
  },
}
