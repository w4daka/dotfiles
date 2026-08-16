return {
  'tarides/ocaml.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('ocaml').setup()
  end,
}
