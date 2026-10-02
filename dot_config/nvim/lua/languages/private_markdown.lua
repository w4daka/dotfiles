-- install without yarn or npm
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
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
        open_browser = true,
        default_theme = 'dark', -- "dark" or "light"; initial preview theme
        debounce_ms = 300,
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
