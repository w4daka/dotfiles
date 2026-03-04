return {

  {
    'delphinus/skkeleton_indicator.nvim',
    config = function()
      require('skkeleton_indicator').setup {}
    end,
  },
  {
    'vim-skk/skkeleton',
    dependencies = {
      'vim-denops/denops.vim',
      'Shougo/ddc.vim',
      'Shougo/ddc-ui-pum',
    },
    config = function()
      vim.fn['skkeleton#config'] {
        globalDictionaries = { '~/.skk/SKK-JISYO.L' },
        eggLikeNewline = true,
      }
      vim.cmd [[call ddc#custom#patch_global('sources', ['skkeleton', 'skkeleton_okuri'])]]
      vim.cmd [[call ddc#custom#patch_global('sourceOptions', {
        \   '_': {
        \     'matchers': ['matcher_head'],
        \     'sorters': ['sorter_rank']
        \   },
        \   'skkeleton': {
        \     'mark': 'SKK',
        \     'matchers': [],
        \     'sorters': [],
        \     'converters': [],
        \     'isVolatile': v:true,
        \     'minAutoCompleteLength': 1,
        \   },
        \   'skkeleton_okuri': {
        \     'mark': 'SKK*',
        \     'matchers': [],
        \     'sorters': [],
        \     'converters': [],
        \     'isVolatile': v:true,
        \   },
        \ })
        ]]

      vim.cmd [[call skkeleton#config({'completionRankFile': '~/.skk/rank.json'})]]
      vim.cmd [[ call ddc#enable() ]]
      vim.cmd [[call ddc#custom#patch_global('ui','pum')]]
    end,
  },
}
