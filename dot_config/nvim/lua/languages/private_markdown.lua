-- install without yarn or npm
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  -- ref https://github.com/selimacerbas/markdown-preview.nvim
  {
    'selimacerbas/markdown-preview.nvim',
    dependencies = { 'selimacerbas/live-server.nvim' },
    config = function()
      require('markdown_preview').setup({
        -- all optional; sane defaults shown
        instance_mode = 'takeover', -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        debounce_ms = 300,
        default_theme = 'light',
      })
      vim.keymap.set(
        'n',
        '<leader>mps',
        '<cmd>MarkdownPreview<cr>',
        { desc = 'Markdown: Start preview' }
      )
      vim.keymap.set(
        'n',
        '<leader>mpS',
        '<cmd>MarkdownPreviewStop<cr>',
        { desc = 'Markdown: Stop preview' }
      )
      vim.keymap.set(
        'n',
        '<leader>mpr',
        '<cmd>MarkdownPreviewRefresh<cr>',
        { desc = 'Markdown: Refresh preview' }
      )
    end,
  },
}
