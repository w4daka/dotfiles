return {
  'folke/lazydev.nvim',
  ft = 'lua', -- luaファイルを開いたときだけ読み込む
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } }, -- vim.uv の型を補完
    },
  },
}
