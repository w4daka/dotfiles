return {
  -- 1. 基盤・コア
  { 'vim-denops/denops.vim', lazy = false },
  {
    'Shougo/ddc.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      local patch_global = vim.fn['ddc#custom#patch_global']

      patch_global('ui', 'pum')
      patch_global('sources', { 'lsp', 'skkeleton', 'around' })

      patch_global('sourceOptions', {
        ['_'] = {
          matchers = { 'matcher_head' },
          sorters = { 'sorter_rank' },
        },
        lsp = {
          mark = 'LSP',
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        },
        skkeleton = {
          mark = 'skk',
          isVolatile = true,
          minAutoCompleteLength = 1,
        },
        copilot = {
          mark = 'Co',
          matchers = { 'matcher_head' },
          sorters = { 'sorter_rank' },
          minAutoCompleteLength = 0,
          isVolatile = true,
          forceCompletionPattern = [[\w+]],
          timeout = 2000,
        },
        around = {
          mark = 'A',
        },
      })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = vim.fn.expand '~' .. '/blog/content/post/english_practice_1/index.md',
        callback = function()
          vim.fn['ddc#custom#patch_buffer']('sources', {})
        end,
      })

      patch_global('sourceParams', {
        copilot = {
          enterprise = false,
        },
      })

      vim.fn['ddc#enable']()
    end,
  },

  -- 2. UI
  { 'Shougo/pum.vim', lazy = false },
  { 'Shougo/ddc-ui-pum' },

  -- 3. Copilot (本体 + ddcソース)
  -- {
  --   'github/copilot.vim',
  --   lazy = false,
  --   config = function()
  --     vim.g.copilot_no_maps = true
  --
  --     -- ドキュメントに基づいたファイルタイプ別の無効化設定
  --     vim.g.copilot_filetypes = {
  --       markdown = false, -- markdownを無効化
  --       text = false, -- ついでにテキストファイルも無効化する場合
  --     }
  --   end,
  -- },
  -- { 'Shougo/ddc-source-copilot', dependencies = { 'github/copilot.vim' } },

  -- 4. その他ソース・フィルター
  { 'Shougo/ddc-source-lsp' },
  { 'Shougo/ddc-source-around' },
  { 'Shougo/ddc-filter-sorter_rank' },
  { 'Shougo/ddc-filter-matcher_head' },

  -- 5. Skkeleton (元のまま)
  {
    'vim-skk/skkeleton',
    lazy = false,
    config = function()
      vim.fn['skkeleton#config'] {
        kanaTable = 'rom',
        globalDictionaries = { '~/.skk/SKK-JISYO.L' },
        eggLikeNewline = true,
        keepState = true,
      }

      local opts = { noremap = true, silent = true }
      vim.keymap.set({ 'i', 'c', 't' }, '<C-j>', '<Plug>(skkeleton-toggle)', { noremap = false })
      vim.keymap.set({ 'i', 'c' }, '<C-n>', '<cmd>call pum#map#insert_relative(+1)<CR>', opts)
      vim.keymap.set({ 'i', 'c' }, '<C-p>', '<cmd>call pum#map#insert_relative(-1)<CR>', opts)
      vim.keymap.set({ 'i', 'c' }, '<C-y>', '<cmd>call pum#map#confirm()<CR>', opts)
      vim.keymap.set({ 'i', 'c' }, '<C-e>', '<cmd>call pum#map#cancel()<CR>', opts)
    end,
  },
  {
    'delphinus/skkeleton_indicator.nvim',
    config = function()
      require('skkeleton_indicator').setup {}
    end,
  },
}
