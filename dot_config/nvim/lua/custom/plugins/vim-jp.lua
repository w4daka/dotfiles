return {
  {
    'vim-jp/vimdoc-ja',

    lazy = true,
    event = 'VeryLazy',
    config = function()
      vim.opt.helplang:prepend 'ja'
    end,
  },
}
