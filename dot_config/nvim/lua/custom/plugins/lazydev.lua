return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      { path = 'lazy.nvim' },
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
