-- install without yarn or npm
return {
  {
    'delphinus/md-render.nvim',
    version = '*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', version = '*' }, -- optional: file type icons in code blocks
      { 'delphinus/budoux.lua', version = '*' }, -- optional: CJK phrase-level line breaking
    },
    keys = {
      { '<leader>mdp', '<Plug>(md-render-preview)', desc = 'Markdown preview (toggle)' },
      { '<leader>mdt', '<Plug>(md-render-preview-tab)', desc = 'Markdown preview in tab (toggle)' },
      { '<leader>mdd', '<Plug>(md-render-demo)', desc = 'Markdown render demo' },
      { '<leader>mda', '<Plug>(md-render-auto)', desc = 'Markdown render auto' },
      { '<leader>mds', '<Plug>(md-render-split)', desc = 'Markdown render split' },
    },
    -- config = function ()
    --
    -- end
  },
  {
    'selimacerbas/mdkite.nvim',
    -- a kitehost.nvim checkout under another dir name needs its spec to
    -- say name = "kitehost.nvim", or lazy.nvim clones upstream beside it
    dependencies = { 'selimacerbas/kitehost.nvim' },
    -- kitehost.nvim v2.0.0 or newer, the first release with its Host check
    config = function()
      require('mdkite').setup({
        -- all optional; sane defaults shown
        instance_mode = 'takeover', -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        default_theme = 'dark', -- "dark" or "light"; initial preview theme
        debounce_ms = 300,
        host = '0.0.0.0',
        open_browser = false,
        hooks = {
          on_start = function(url)
            vim.notify('mdkite: ' .. url, vim.log.levels.INFO)
          end,
        },
      })
      vim.keymap.set(
        'n',
        '<leader>mps',
        '<cmd>MdKite start<cr>',
        { desc = 'Markdown: Start preview' }
      )
      vim.keymap.set(
        'n',
        '<leader>mpS',
        '<cmd>MdKite stop<cr>',
        { desc = 'Markdown: Stop preview' }
      )
      vim.keymap.set(
        'n',
        '<leader>mpr',
        '<cmd>MdKite  refresh<cr>',
        { desc = 'Markdown: Refresh preview' }
      )
    end,
  },
}
